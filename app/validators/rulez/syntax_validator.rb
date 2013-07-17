module Rulez
  class SyntaxValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      if !value || !Parser.parse(value)
        object.errors[attribute] << (options[:message] || "is not a valid expression.")
      end
    end
  end
end
