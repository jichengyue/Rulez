require 'whittle'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_syntax_analyzer.rb')
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_parser.rb')

module Rulez
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
  end

  def self.is_rule_valid?(rule)
    rule = Rule.find_by_name(rule)
    if rule
      parser = RulezParser.new
      parser.parse(rule.rule)
    else
      raise 'No such rule!'
    end
  end

  class Parser
    @@arr = []
    def self.parse(input)
      @@arr = []
      analyzer = SyntaxAnalyzer.new
      analyzer.parse(input)
    end

    def self.add_new_symbol(v)
      @@arr.push(v)
    end

    def self.symbols_list
      @@arr
    end
  end

end
