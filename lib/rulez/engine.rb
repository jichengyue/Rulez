require 'treetop'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser/rulezgrammar.rb')

module Rulez
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
  end

  class RulezParser
    # instantiate the parser
    @@parser = RulezGrammarParser.new

    # 
    # parse top down the incoming input data
    # @param  data  string that describe the rule to be parsed
    # 
    # @return Treetop::Runtime::SyntaxNode 
    def self.parse(data)
      tree = @@parser.parse(data)

      # aggiungere qui un controllo di errore sul tree
      # se tree.nil? allora il parsing non ha avuto successo

      return tree
    end

    def self.TypeDate(d)
      Date.strptime(d,'%d//%m//%Y')
    end

    def self.TypeDateTime(dt)
      DateTime.strptime(dt,'%d//%m//%Y#%H:%M:%S')
    end
  end

end
