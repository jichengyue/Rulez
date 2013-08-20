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
      rule.context.symbols.each do |s|
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
    symbols = Rulez::Symbol.all
    
    existing_models = @@models.map { |m| m.name }

    symbols.each do |s|
      if !existing_models.include? s.model
        errors << { 
          level: :error, 
          type: "Symbol", 
          description: "Symbol #{s.name} refers to non-existent model: #{s.model}",
          ref: s
        }
      end
    end

    rules.each do |r|
      if !r.valid?
        r.errors.each do |e|
          errors << {
            level: :error,
            type: "Rule",
            description: e.error,
            ref: r
          }
        end
      end
    end

    errors
  end

  # 
  # Set the target of the rulez engine, from which the engine can fetch the requested symbols.
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
    # Add a symbol to the context symbol table
    # @param  v [String] Symbol to add
    # 
    def self.add_new_context_symbol(v)
      @@context_list.push(v)
    end

    #
    # Returns the array of context symbols
    # 
    def self.context_symbols_list
      @@context_list
    end

    # 
    # Add a symbol to the symbol table
    # @param  v [String] The symbol to add
    # 
    def self.add_new_symbol(v)
      @@arr.push(v)
    end

    # 
    # Returns the array of symbols
    # 
    def self.symbols_list
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
