require 'whittle'

class RulezParser < Whittle::Parser

  rule(:wsp => /\s+/).skip!

  rule("||") % :left ^ 1
  rule("&&") % :left ^ 2
  rule("==")
  rule("!=")
  rule("<=")
  rule(">=")
  rule("<")
  rule(">")
  rule("+") % :left ^ 3
  rule("-") % :left ^ 3
  rule("*") % :left ^ 4
  rule("/") % :left ^ 4
  rule("(") ^ 5
  rule(")") ^ 5
  rule("!") % :left ^ 6

  rule(:bool_operation) do |r|
    r["(", :bool_operation, ")"].as { |_, a, _| (a) }
    r["!", :bool_operation].as { |_, a| !a }
    r[:bool_operation, "||", :bool_operation].as { |a, _, b| a || b }
    r[:bool_operation, "&&", :bool_operation].as { |a, _, b| a && b }
    r[:bool_operand]
  end

  rule(:bool_operand) do |r|
    r[:boolean_value]
    r[:cmp_operation]
  end

  rule(:cmp_operation) do |r|
    r[:cmp_operand, ">", :cmp_operand].as { |a, _, b| a > b }
    r[:cmp_operand, "<", :cmp_operand].as { |a, _, b| a < b }
    r[:cmp_operand, ">=", :cmp_operand].as { |a, _, b| a >= b }
    r[:cmp_operand, "<=", :cmp_operand].as { |a, _, b| a <= b }
    r[:cmp_operand, "!=", :cmp_operand].as { |a, _, b| a != b }
    r[:cmp_operand, "==", :cmp_operand].as { |a, _, b| a == b }
    r[:cmp_operand, ">", :boolean_value].as { |a, _, b| a > b }
    r[:cmp_operand, "<", :boolean_value].as { |a, _, b| a < b }
    r[:cmp_operand, ">=", :boolean_value].as { |a, _, b| a >= b }
    r[:cmp_operand, "<=", :boolean_value].as { |a, _, b| a <= b }
    r[:cmp_operand, "!=", :boolean_value].as { |a, _, b| a != b }
    r[:cmp_operand, "==", :boolean_value].as { |a, _, b| a == b }
  end

  rule(:cmp_operand) do |r|
    r[:math_operation]
    r[:variable_value]
  end

  rule(:math_operation) do |r|
    r["(", :math_operation, ")"].as { |_, a, _| (a) }
    r["-", :math_operation].as { |_, a| -a }
    r[:math_operation, "/", :math_operation].as { |a, _, b| a / b }
    r[:math_operation, "*", :math_operation].as { |a, _, b| a * b }
    r[:math_operation, "-", :math_operation].as { |a, _, b| a - b }
    r[:math_operation, "+", :math_operation].as { |a, _, b| a + b }
    r[:math_operand]
  end

  rule(:math_operand) do |r|
    r[:datetime_value]
    r[:date_value]
    r[:string_value]
    r[:float_value]
    r[:integer_value]
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

  rule(string_value: /\"[a-zA-Z0-9 ]*\"/).as { |s| String.new(s[1..(s.length-2)]) }


  #new variable value per contesti: [a-zA-Z][a-zA-Z0-9_]*[.][a-zA-Z][a-zA-Z0-9_]*|[a-zA-Z][a-zA-Z0-9_]*
  # questa regola fa il match di variabile.metodo...
  
  rule(function: /[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    if Rulez.get_methods_class.methods(false).map { |s| s.to_s }.include?(s)
      Rulez.get_methods_class.method(s).call
    else
      raise "Missing method #{s}! Did you delete methods in your lib?"
    end
  end

  rule(context_variable: /[a-zA-Z][a-zA-Z0-9_]*[.][a-zA-Z][a-zA-Z0-9_]*|[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    splitted = s.split('.')
    left = splitted.first
    right = splitted.last
    context_variables = Rulez::Parser.get_context_variables

    if context_variables.blank?
      raise "Context variables not found."
    end

    if context_variables[left]
      context_variables[left].send(right)
    else
      raise "Missing variable @#{left}. Did you initialized all the variables of this context?"
    end
  end

  rule(:variable_value) do |r|
    r[:context_variable]
    r[:function]
  end

  rule(float_value: /([1-9][0-9]*|0)?\.[0-9]+/).as { |s| s.to_f }

  rule(integer_value: /[1-9][0-9]*|0/).as { |s| s.to_i }

  start(:bool_operation)

end
