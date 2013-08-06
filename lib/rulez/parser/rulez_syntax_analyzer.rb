require 'whittle'

class SyntaxAnalyzer < Whittle::Parser

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
    r[:expr, "&&", :expr]
    r[:expr, "||", :expr]
    r[:expr, "==", :expr]
    r[:expr, "!=", :expr]
    r[:expr, "<=", :expr]
    r[:expr, ">=", :expr]
    r[:expr, "<", :expr]
    r[:expr, ">", :expr]
    r[:expr, "+", :expr]
    r[:expr, "-", :expr]
    r[:expr, "*", :expr]
    r[:expr, "/", :expr]
    r["-", :expr]
    r["(", :expr, ")"]
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

  rule(boolean_value: /true|false/)

  rule(datetime_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})(\#)([01][0-9]|2[0-3])(\:)([0-5][0-9])(\:)([0-5][0-9])/
  )
 
  rule(date_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})/
  )

  rule(method_symbol: /[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    Rulez::Parser.add_new_symbol(s)
  end

  rule(context_symbol: /[a-zA-Z][a-zA-Z0-9_]*[.][a-zA-Z][a-zA-Z0-9_]*|[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    Rulez::Parser.add_new_context_symbol(s)
  end

  rule(:symbol_value) do |r|
    r[:context_symbol]
    r[:method_symbol]
  end

  #rule(symbol_value: /[a-zA-Z][a-zA-Z0-9_]*/).as { |s| Rulez::Parser.add_new_symbol(s) }

  rule(float_value: /([1-9][0-9]*|0)?\.[0-9]+/)

  rule(integer_value: /[1-9][0-9]*|0/)

  start(:expr)
end
