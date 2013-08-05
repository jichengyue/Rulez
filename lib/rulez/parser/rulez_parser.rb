require 'whittle'

class RulezParser < Whittle::Parser

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
    r["!", :expr].as { |_, a| !a }
    r[:expr, "&&", :expr].as { |a, _, b| a && b }
    r[:expr, "||", :expr].as { |a, _, b| a || b }
    r[:expr, "==", :expr].as { |a, _, b| a == b }
    r[:expr, "!=", :expr].as { |a, _, b| a != b }
    r[:expr, "<=", :expr].as { |a, _, b| a <= b }
    r[:expr, ">=", :expr].as { |a, _, b| a >= b }
    r[:expr, "<", :expr].as { |a, _, b| a < b }
    r[:expr, ">", :expr].as { |a, _, b| a > b }
    r[:expr, "+", :expr].as { |a, _, b| a + b }
    r[:expr, "-", :expr].as { |a, _, b| a - b }
    r[:expr, "*", :expr].as { |a, _, b| a * b }
    r[:expr, "/", :expr].as { |a, _, b| a / b }
    r["-", :expr].as { |_, a| -a }
    r["(", :expr, ")"].as { |_, a, _| (a) }
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

  rule(boolean_value: /true|false/).as do |s|
    if s == 'true'
      true
    else
      false
    end
  end

  rule(datetime_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})(\#)([01][0-9]|2[0-3])(\:)([0-5][0-9])(\:)([0-5][0-9])/
  ).as { |s| DateTime.strptime(s, '%d//%m//%Y#%H:%M:%S') }
  #TODO: timezone? example with timezone: DateTime.strptime('2001-02-03T04:05:06+07:00', '%Y-%m-%dT%H:%M:%S%z')
 
  rule(date_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})/
  ).as { |s| Date.strptime(s, '%d//%m//%Y') }

  rule(symbol_value: /[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    if Rulez.get_methods_class.methods(false).map { |s| s.to_s }.include?(s)
      Rulez.get_methods_class.method(s).call
    else
      #esecuzione della funzione del contesto (se è del contesto!)
    end
  end

  rule(float_value: /([1-9][0-9]*|0)?\.[0-9]+/).as { |s| s.to_f }

  rule(integer_value: /[1-9][0-9]*|0/).as { |s| s.to_i}

  start(:expr)
end
