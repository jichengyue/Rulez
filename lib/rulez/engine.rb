require 'whittle'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_syntax_analyzer.rb')
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_parser.rb')

# 
# The rulez engine
# 
module Rulez


  # 
  # Isolate the Rulez namespace
  # 
  class Engine < ::Rails::Engine
    isolate_namespace Rulez

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end
  end


  # 
  # Evaluates a rule
  # @param [String] rule the name of the rule to evaluate
  # 
  # @return [Boolean] the result of the rule evaluated
  def self.rulez?(rule)
    rule = Rule.find_by_name(rule)
    if rule
      if @target.nil?
        raise "Target object not found. Did you forget to set the target?"
      end

      #set context variables
      context_variables = {}
      rule.context.variables.each do |s|
        context_variables[s.name] = @target.instance_variable_get(("@" + s.name).to_sym)
      end
      Parser.set_context_variables(context_variables)

      parser = RulezParser.new

      parser.parse(rule.rule)
    else
      raise 'No such rule!'
    end
  end

  # 
  # Looks for errors in the whole engine logic
  # 
  # @return [Array] a list of errors and warnings, ordered by priority
  def self.doctor
    errors = []

    rules = Rule.all
    variables = Rulez::Variable.all
    
    existing_models = @@models.map { |m| m.name }

    variables.each do |s|
      if !existing_models.include? s.model
        errors << { 
          level: :error, 
          type: "Variable", 
          description: "Variable #{s.name} refers to non-existent model: #{s.model}",
          ref: s
        }
      end
    end

    rules.each do |r|
      if !r.valid?
        r.errors.messages.each do |k, v|
          errors << {
            level: :error,
            type: "Rule",
            description: "#{k.to_s} => " + v.join(', '),
            ref: r
          }
        end
      end
    end

    errors
  end

  # 
  # Set the target of the rulez engine, from which the engine can fetch the requested variables.
  # 
  # @param  obj [Object] the target object
  # 
  def self.set_rulez_target(obj)
    @target = obj
  end

  # 
  # The rule parser
  # 
  class Parser
    @@arr = []

    @@context_list = []

    # 
    # Parse the input
    # @param  input [String] the expression to parse
    # 
    def self.parse(input)
      @@arr = []
      @@context_list = []
      @@context_variables = {}
      analyzer = SyntaxAnalyzer.new
      analyzer.parse(input)
    end

    #
    # Add a variable to the context variable table
    # @param  v [String] Variable to add
    # 
    def self.add_new_context_variable(v)
      @@context_list.push(v)
    end

    #
    # Returns the array of context variables
    # 
    def self.context_variables_list
      @@context_list
    end

    # 
    # Add a variable to the variable table
    # @param  v [String] The variable to add
    # 
    def self.add_new_variable(v)
      @@arr.push(v)
    end

    # 
    # Returns the array of variables
    # 
    def self.variables_list
      @@arr
    end

    # 
    # set the context variables from the application
    # 
    # @param  hash [Hash] the context variables (the keys are the names, the values are the real values)
    # 
    def self.set_context_variables(hash)
      @@context_variables = hash
    end

    # 
    # get the context variables
    # 
    # @return [Hash] All context variables
    def self.get_context_variables
      @@context_variables
    end
  end

end
