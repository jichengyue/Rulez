module Rulez

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
          Parser.parse(value)

          if object.context

            # check all functions
            parsed = Parser.symbols_list
            parsed = parsed - Rulez.get_methods_class.methods(false).map { |s| s.to_s } #check functions
            if !parsed.empty?
              object.errors[attribute] << "expression contains invalid symbols: #{parsed.join(', ')}."
            end

            # check all symbols
            Parser.context_symbols_list.each do |context_symbol|
              # split symbol from method
              splitted = context_symbol.split('.')
              symbol_object = splitted.first
              symbol_method = splitted.last

              # check if symbol is permitted
              symbol_class_name = false
              object.context.symbols.each do |s|
                if s.name == symbol_object
                  symbol_class_name = s.model
                  break
                end
              end

              # check if symbol is permitted
              if symbol_class_name
                # check if method is permitted
                valid_methods = eval "#{symbol_class_name}.new.methods(false)"
                valid_methods += (eval "#{symbol_class_name}.new.attribute_names")
                if !valid_methods.include?(symbol_method)
                  object.errors[attribute] << "not valid: #{symbol_method} is not a valid method/attribute for #{symbol_object}."
                end
              else
                object.errors[attribute] << "expression contains invalid symbol: #{symbol_object}."
              end
            end
          end

        rescue
          object.errors[attribute] << "is not a valid expression, parse error."
        end
      end
    end

  end
end
