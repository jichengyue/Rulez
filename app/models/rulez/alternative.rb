module Rulez

  # 
  # Describes an alternative to a rule.
  # When its condition is true, the alternative substitute the original rule.
  # 
  class Alternative < ActiveRecord::Base
    attr_accessible :description, :condition, :alternative

    belongs_to :rule
    has_one :context, through: :rule

    # validations
    validates :description, :rule, presence: true
    validates :condition, :alternative, presence: true, syntax: true
    validates :priority, presence:true, numericality: true
  end
end
