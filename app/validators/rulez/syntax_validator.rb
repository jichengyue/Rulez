module Rulez

  class SyntaxValidator < ActiveModel::EachValidator

    def validate_each(object, attribute, value)
      if value
        begin
          Parser.parse(value)

          if object.context
            if !(Parser.symbols_list - object.context.symbols.map {|s| s.name}).empty?
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
