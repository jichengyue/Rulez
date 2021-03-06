require 'whittle'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_syntax_analyzer.rb')
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_parser.rb')
require File.join(File.expand_path(File.dirname(__FILE__)),'exceptions.rb')

# 
# The rulez engine
# 
module Rulez

  # 
  # Isolate the Rulez namespace
  # 
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
    require 'jquery-ui-rails'

    #Rspec configuration
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end

    #logger configuration
    @@rulez_logger = nil
    @@file_log = nil
    initializer :logger do |app|
      @@file_log = File.open('log/rulez.log', 'a')
      @@rulez_logger = ActiveSupport::TaggedLogging.new( Logger.new( @@file_log ) )
      Engine::info_log('Rulez waking up!')
    end

    # importing methods and models 
    initializer :methods_and_models do |app|
      # sets the methods class
      if (path = Pathname.new(Rails.root + "lib/rulez_methods.rb")).exist?
        require path
      else
        require "#{Rulez::Engine.root}/lib/tasks/templates/rulez_methods.rb"
      end
      Rulez.set_methods_class(RulezMethods::Methods)

      # sets the models
      Dir[Rails.root + "app/models/**/*.rb"].each do |path|
        require path
      end
      Rulez.set_models(ActiveRecord::Base.send :descendants)
    end
    
    # 
    # Writes out on the log file a debug level message
    # @param  message [String] the message
    # 
    def self.debug_log(message)
      @@rulez_logger.tagged('DEBUG', DateTime.now) { @@rulez_logger.debug message }
    end

    # 
    # Writes out on the log file an info level message
    # @param  message [String] the message
    # 
    def self.info_log(message)
      @@rulez_logger.tagged('INFO', DateTime.now) { @@rulez_logger.info message }
    end

    # 
    # Writes out on the log file an error level message
    # @param  message [String] the message
    # 
    def self.error_log(message)
      @@rulez_logger.tagged('ERROR', DateTime.now) { @@rulez_logger.error message }
    end

    # 
    # Writes out on the log file a fatal level message
    # @param  message [String] the message
    # 
    def self.fatal_log(message)
      @@rulez_logger.tagged('FATAL', DateTime.now) { @@rulez_logger.fatal message }
    end

    # 
    # Writes out on the log file a warning level message
    # @param  message [String] the message
    # 
    def self.warning_log(message)
      @@rulez_logger.tagged('WARNING', DateTime.now) { @@rulez_logger.warn message }
    end


    # 
    # flush the log file
    # 
    def self.flush_log
      @@file_log.flush
    end

  end


  # 
  # Evaluates a rule
  # @param rule [String] the name of the rule to evaluate
  # @param params [Hash] the params of the evaluating rule (if present)
  # 
  # @return [Boolean] the result of the rule evaluated
  def self.rulez?(rule, params = {})
    rule = Rule.find_by_name(rule)
    if rule
      if @target.nil?
        Engine::fatal_log("Evaluating #{rule.name}: Target object not found. Did you forget to set the target?")
        raise Rulez::TargetMissingError, "Target object not found. Did you forget to set the target?"
      end

      #set context variables
      context_variables = {}
      rule.context.variables.each do |s|
        context_variables[s.name] = @target.instance_variable_get(("@" + s.name).to_sym)
      end
      Parser.set_context_variables(context_variables)
      Parser.set_parameters(params)

      configured_parameters = params.map { |k, v| k.to_s }
      requested_parameters = rule.get_parameters_list
      
      # checks if mandatory parameters are all set
      mandatory_parameters_check = requested_parameters - configured_parameters
      if !mandatory_parameters_check.empty?
        Engine::fatal_log("Evaluating #{rule.name}: mandatory parameters not set: " + mandatory_parameters_check.join(', '))
        raise Rulez::WrongParametersError, "Mandatory parameters not set: " + mandatory_parameters_check.join(', ')
      end

      extra_parameters_check = configured_parameters - requested_parameters
      if !extra_parameters_check.empty?
        Engine::error_log("Evaluating #{rule.name}: too many parameters set: " + extra_parameters_check.join(', ') + " are not requested")
      end

      parser = RulezParser.new

      evaluated = false
      value = false
      rule.alternatives.sort { |a, b| a.priority <=> b.priority }.each do |alternative|
        if parser.parse(alternative.condition)
          evaluated = true
          value = parser.parse(alternative.alternative)
          break
        end
      end
      value = parser.parse(rule.rule) if !evaluated
      
      Engine::info_log("Evaluated #{rule.name}: #{value}")
      value
    else
      Engine::fatal_log("Can't find rule #{rule.name} to evaluate!")
      raise Rulez::RuleMissingError, "Can't find rule #{rule.name} to evaluate!"
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
    alternatives = Rulez::Alternative.all
    
    existing_models = @@models.map { |m| m.name }

    variables.each do |s|
      if !existing_models.include? s.model
        errors << { 
          level: :error, 
          type: "Variable", 
          description: "Variable #{s.name} refers to non-existent model: #{s.model}",
          name: s.name,
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
            name: r.name,
            ref: r
          }
        end
      end
    end

    alternatives.each do |a|
      if !a.valid?
        a.errors.messages.each do |k, v|
          errors << {
            level: :error,
            type: "Alternative",
            description: "#{k.to_s} => " + v.join(', '),
            name: a.description,
            ref: a
          }
        end
      end
    end

    if errors.count == 0
      Engine::info_log("Doctor invoked, no errors found.")
    else
      s = "Doctor invoked, errors found! "
      errors.each do |error|
        s += " -- #{error[:description]} -- "
      end
      Engine::error_log(s)
    end

    errors
  end

  # 
  # Set the target of the rulez engine, from which the engine can fetch the requested variables.
  # 
  # @param  obj [Object] the target object
  # 
  def self.set_rulez_target(obj)
    Engine::debug_log("Target set: #{obj}")
    @target = obj
  end

  # 
  # The rule parser
  # 
  class Parser
    @@function_list = []

    @@context_list = []
    
    # 
    # Parse the input
    # @param  input [String] the expression to parse
    # 
    def self.parse(input)
      @@function_list = []
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
    def self.add_new_function(v)
      @@function_list.push(v)
    end

    # 
    # Returns the array of variables
    # 
    def self.functions_list
      @@function_list
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

    # 
    # set the parameters for evaluating the rule from the application
    # 
    # @param params [Hash] the parameters (the keys are the names, the values are the real values)
    # 
    def self.set_parameters(params = {})
      @@parameters = params
    end

    # 
    # get the parameters
    # 
    # @return [Hash] the parameters of the rule
    def self.get_parameters
      @@parameters
    end
  end

end
