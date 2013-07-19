module Rulez
  class SyntaxValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      tree = Parser.parse(value.gsub(/\s+/, '')) if value
      if !value || !tree
        object.errors[attribute] << (options[:message] || "is not a valid expression: parse error")
      else
        object.errors[attribute] << check_ids(tree, object.context.symbols)
      end
    end

  private
    def check_ids(t, valid_symbols)
      if !t
        nil
      end

      if t.extension_modules[0].to_s.sub(/.*:/,'').include?("SYMBOL")
        return " is not a valid expression: '#{t.text_value}' is not a valid symbol for this context" if !valid_symbols.include?(t.text_value)
      end

      t.elements.each do |el|
        val = check_ids(el, valid_symbols)
        return val if val
      end

      nil
    end
  end
end
