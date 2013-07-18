module Rulez
  class Symbol < ActiveRecord::Base
    attr_accessible :description, :name

    has_and_belongs_to_many :context, join_table: :rulez_contexts_symbols
  end
end
