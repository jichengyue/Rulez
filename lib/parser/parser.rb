require 'treetop'

# load custom syntax node extension module 
require File.join(File.expand_path(File.dirname(__FILE__)),'node_extensions.rb')

class Parser
  # retrive current base path
  @@base_path = File.expand_path(File.dirname(__FILE__))
  # create the parser class from the grammar defined in rulezgrammar.treetop
  Treetop.load(File.join(@@base_path,'rulezgrammar.treetop'))
  # instantiate the parser
  @@parser = RulezGrammarParser.new


  # 
  # parse top down the incoming input data
  # @param  data  string that describe the rule to be parsed
  # 
  # @return Treetop::Runtime::SyntaxNode 
  def self.parse(data)
    tree = @@parser.parse(data)
    #self.clean_tree(tree)
    return tree
  end

  private 
    def self.clean_tree(root_node)
      return if(root_node.elements.nil?)
      root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
      root_node.elements.each {|node| self.clean_tree(node) }
    end

end