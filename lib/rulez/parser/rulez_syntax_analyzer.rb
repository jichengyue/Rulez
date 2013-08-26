require 'whittle'

class SyntaxAnalyzer < Whittle::Parser

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
    r["(", :bool_operation, ")"]
    r["!", :bool_operation]
    r[:bool_operation, "||", :bool_operation]
    r[:bool_operation, "&&", :bool_operation]
    r[:bool_operand]
  end

  rule(:bool_operand) do |r|
    r[:boolean_value]
    r[:cmp_operation]
  end

  rule(:cmp_operation) do |r|
    r[:cmp_operand, ">", :cmp_operand]
    r[:cmp_operand, "<", :cmp_operand]
    r[:cmp_operand, ">=", :cmp_operand]
    r[:cmp_operand, "<=", :cmp_operand]
    r[:cmp_operand, "!=", :cmp_operand]
    r[:cmp_operand, "==", :cmp_operand]
    r[:cmp_operand, ">", :boolean_value]
    r[:cmp_operand, "<", :boolean_value]
    r[:cmp_operand, ">=", :boolean_value]
    r[:cmp_operand, "<=", :boolean_value]
    r[:cmp_operand, "!=", :boolean_value]
    r[:cmp_operand, "==", :boolean_value]
  end

  rule(:cmp_operand) do |r|
    r[:math_operation]
    r[:variable_value]
  end

  rule(:math_operation) do |r|
    r["(", :math_operation, ")"]
    r["-", :math_operation]
    r[:math_operation, "/", :math_operation]
    r[:math_operation, "*", :math_operation]
    r[:math_operation, "-", :math_operation]
    r[:math_operation, "+", :math_operation]
    r[:math_operand]
  end

  rule(:math_operand) do |r|
    r[:datetime_value]
    r[:date_value]
    r[:string_value]
    r[:float_value]
    r[:integer_value]
  end

  rule(boolean_value: /true|false/) 

  rule(datetime_value: 
      /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})(\#)([01][0-9]|2[0-3])(\:)([0-5][0-9])(\:)([0-5][0-9])/
    )

  rule(date_value: 
    /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})/
  )

  rule(string_value: /\"[a-zA-Z0-9 ]*\"/)

  rule(function: /[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    Rulez::Parser.add_new_function(s)
  end

  rule(context_variable: /[a-zA-Z][a-zA-Z0-9_]*[.][a-zA-Z][a-zA-Z0-9_]*|[a-zA-Z][a-zA-Z0-9_]*/).as do |s|
    Rulez::Parser.add_new_context_variable(s)
  end

  rule(:variable_value) do |r|
    r[:context_variable]
    r[:function]
  end
    
  rule(float_value: /([1-9][0-9]*|0)?\.[0-9]+/)

  rule(integer_value: /[1-9][0-9]*|0/)

  start(:bool_operation)
end
