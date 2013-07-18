module Rulez
  class Context < ActiveRecord::Base
    attr_accessible :description, :name

    has_many :rules
    has_and_belongs_to_many :symbols, join_table: :rulez_contexts_symbols
  end
end
