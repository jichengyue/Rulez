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
  end


  # 
  # Evaluates a rule
  # @param [String] the name of the rule to evaluate
  # 
  # @return [Boolean] the result of the rule evaluated
  def self.rulez?(rule)
    rule = Rule.find_by_name(rule)
    if rule
      parser = RulezParser.new
      parser.parse(rule.rule)
    else
      raise 'No such rule!'
    end
  end

  # 
  # The rule parser
  # 
  class Parser
    @@arr = []

    # 
    # Parse the input
    # @param  input [String] the expression to parse
    # 
    def self.parse(input)
      @@arr = []
      analyzer = SyntaxAnalyzer.new
      analyzer.parse(input)
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
  end

end
