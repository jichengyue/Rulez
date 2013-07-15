require 'treetop'
require File.join(File.expand_path(File.dirname(__FILE__)),'parser.rb')

tree = Parser.parse("simbolomio")

p tree

# per parsare DATE --> d = Date.strptime('31//12//2013','%d//%m//%Y')
# per parsare DATETIME --> dt = DateTime.strptime('31//12//2013#13:05:59','%d//%m//%Y#%H:%M:%S')
