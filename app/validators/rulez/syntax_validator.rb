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
            parsed = Parser.symbols_list
            #parsed = parsed - object.context.symbols.map { |s| s.name } #check symbols
            parsed = parsed - Rulez.get_methods_class.methods(false).map { |s| s.to_s } #check functions
            if !parsed.empty?
              object.errors[attribute] << 'expression contains invalid symbols.'
            end

            Parser.context_symbols_list.each do |context_symbol|
              splitted = context_symbol.split('.')
              symbol_object = splitted.first.to_sym
              symbol_method = splitted.last.to_sym
              #do the check right here
              symbols = object.context.symbols.map { |s| s.name }.each do |object_symbols|

              end
            end
          end

        rescue
          object.errors[attribute] << 'is not a valid expression, parse error.'
        end
      end
    end

  end
end
