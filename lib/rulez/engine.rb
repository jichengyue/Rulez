require 'whittle'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_syntax_analyzer.rb')

module Rulez
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
  end

  class Parser
    @@arr = []
    def self.parse(input)
      @@arr = []
      parser = SyntaxAnalyzer.new
      parser.parse(input)
    end

    def self.add_new_symbol(v)
      @@arr.push(v)
    end

    def self.symbols_list
      @@arr
    end
  end

end
