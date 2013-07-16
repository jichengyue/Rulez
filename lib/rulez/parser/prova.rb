require 'treetop'
require File.join(File.expand_path(File.dirname(__FILE__)),'rulezparser.rb')
require 'date'

#query_result = "(RulezParser.TypeDateTime(\"16//02//1988#13:04:59\")==RulezParser.TypeDateTime(\"16//02//1988#13:04:59\"))&&(2+3==5)"
query_result = "RulezParser.TypeDateTime(\"16//02//1988#13:05:00\")>RulezParser.TypeDateTime(\"16//02//1988#13:04:59\")"
#query_result = 'a.b.c("3").v("true")'

tree = RulezParser.parse(query_result)

p tree

#p eval(query_result)