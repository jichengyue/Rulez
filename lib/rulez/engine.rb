require 'whittle'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulez_syntax_analyzer.rb')

module Rulez
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
  end

  class Parser
    def self.parse(input)
      parser = SyntaxAnalyzer.new
      parser.parse(input)
      p parser.get_symbols
    end
  end

end
