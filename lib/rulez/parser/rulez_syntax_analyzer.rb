require 'whittle'
require 'date'

class RulezSyntaxAnalyzer < Whittle::Parser

  @@sl = []

  def self.symbols_list
    @@sl
  end

  rule(:wsp => /\s+/).skip!

  rule("!") % :left ^ 1
  rule("&&") % :left ^ 1
  rule("||") % :left ^ 1
  rule("==") ^ 2
  rule("!=") ^ 2
  rule("<=") ^ 2
  rule(">=") ^ 2
  rule("<") ^ 2
  rule(">") ^ 2
  rule("+") % :left ^ 3
  rule("-") % :left ^ 3
  rule("*") % :left ^ 4
  rule("/") % :left ^ 4
  rule("(") ^ 5
  rule(")") ^ 5

  rule(:expr) do |r|
    r["!", :expr]
    r[:expr, "&&", :expr]#.as  { |a, _, b| a && b }
    r[:expr, "||", :expr]#.as  { |a, _, b| a || b }
    r[:expr, "==", :expr]#.as  { |a, _, b| a == b }
    r[:expr, "!=", :expr]#.as  { |a, _, b| a != b }
    r[:expr, "<=", :expr]#.as  { |a, _, b| a <= b }
    r[:expr, ">=", :expr]#.as  { |a, _, b| a >= b }
    r[:expr, "<", :expr]#.as   { |a, _, b| a < b }
    r[:expr, ">", :expr]#.as   { |a, _, b| a > b }
    r[:expr, "+", :expr]#.as   { |a, _, b| a + b }
    r[:expr, "-", :expr]#.as   { |a, _, b| a - b }
    r[:expr, "*", :expr]#.as   { |a, _, b| a * b }
    r[:expr, "/", :expr]#.as   { |a, _, b| a / b }
    r["-", :expr]#.as          { |_, a| -a }
    r["(", :expr, ")"]#.as     { |_, a, _| (a) }
    r[:primary]
  end

  rule(:primary) do |r|
    r[:boolean_value]
    r[:datetime_value]
    r[:date_value]
    r[:float_value]
    r[:integer_value]
    r[:symbol_value]
  end

  rule(boolean_value: /true|false/).as { |b| b == "true" ? true : false; }

  rule(datetime_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})(\#)([01][0-9]|2[0-3])(\:)([0-5][0-9])(\:)([0-5][0-9])/
  ).as { |dt| DateTime.strptime(dt,'%d//%m//%Y#%H:%M:%S') }
 
  rule(date_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})/
  ).as { |d| Date.strptime(d,'%d//%m//%Y') }

  rule(symbol_value: /[a-zA-Z][a-zA-Z0-9_]*/).as { |s| @@sl.push(s) }

  rule(float_value: /([1-9][0-9]*|0)?\.[0-9]+/).as { |f| Float(f) }

  rule(integer_value: /[1-9][0-9]*|0/).as { |i| Integer(i) }

  start(:expr)
end


# ESEMPIO
RulezSyntaxAnalyzer.new.parse("ciao == 3 && var1 < 4 && user_id == 98")
p "lista dei simboli ridotti:"
p RulezSyntaxAnalyzer.symbols_list
##p RulezSyntaxAnalyzer.new.parse("31//10//1988#22:45:07 == 31//10//1988#22:45:07 || 31//10//1988#22:45:07 != 31//10//1988#22:45:07")







