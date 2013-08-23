# 
# Defines a syntax validator for rulez expressions
# 
# @author [author]
# 
class SyntaxValidator < ActiveModel::EachValidator

  # 
  # Custom expression validator
  # 
  def validate_each(object, attribute, value)
    if value
      begin
        Rulez::Parser.parse(value)

        if object.context

          # check all functions
          parsed = Rulez::Parser.variables_list
          parsed = parsed - Rulez.get_methods_class.methods(false).map { |s| s.to_s } #check functions
          if !parsed.empty?
            object.errors[attribute] << "expression contains invalid variables: #{parsed.join(', ')}."
          end

          # check all variables
          Rulez::Parser.context_variables_list.each do |context_variable|
            # split variable from method
            splitted = context_variable.split('.')
            variable_object = splitted.first
            variable_method = splitted.last

            # check if variable is permitted
            variable_class_name = false
            object.context.variables.each do |s|
              if s.name == variable_object
                variable_class_name = s.model
                break
              end
            end

            # check if variable is permitted
            if variable_class_name
              # check if method is permitted
              valid_methods = (eval "#{variable_class_name}.new.public_methods(false)").map { |e| e.to_s }
              valid_methods += (eval "#{variable_class_name}.new.attribute_names")
              if !valid_methods.include?(variable_method)
                object.errors[attribute] << "not valid: #{variable_method} is not a valid method/attribute for #{variable_object}."
              end
            else
              object.errors[attribute] << "expression contains invalid variable: #{variable_object}."
            end
          end
        end

      rescue Exception => e
        debugger
        object.errors[attribute] << "is not a valid expression, parse error."
      end
    end
  end

end