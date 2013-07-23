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


  end
end
