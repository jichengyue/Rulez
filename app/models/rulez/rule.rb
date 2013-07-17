module Rulez
  class Rule < ActiveRecord::Base
    attr_accessible :description, :name, :rule

    #associations
    belongs_to :context

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :rule, presence: true, syntax: true
  end
end
