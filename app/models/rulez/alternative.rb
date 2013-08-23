module Rulez

  # 
  # Describes an alternative to a rule.
  # When its condition is true, the alternative substitute the original rule.
  # 
  class Alternative < ActiveRecord::Base
    attr_accessible :description, :condition, :alternative

    belongs_to :rule

    # validations
    validate :description, :rule, presence: true
    validate :condition, :alternative, presence: true, syntax: true
    validate :priority, presence:true, numericality: true
  end
end
