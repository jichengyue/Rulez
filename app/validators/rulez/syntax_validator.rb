module Rulez

  class SyntaxValidator < ActiveModel::EachValidator

    def validate_each(object, attribute, value)
      if value
        begin
          Parser.parse(value)

          if object.context
            parsed = Parser.symbols_list
            parsed = parsed - object.context.symbols.map { |s| s.name } #check symbols
            parsed = parsed - Rulez.get_methods_class.methods(false).map { |s| s.to_s } #check functions

            if !parsed.empty?
              object.errors[attribute] << 'expression contains invalid symbols.'
            end
          end

        rescue
          object.errors[attribute] << 'is not a valid expression, parse error.'
        end
      end
    end

  end
end
