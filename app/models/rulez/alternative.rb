# == Schema Information
#
# Table name: rulez_alternatives
#
#  id          :integer          not null, primary key
#  description :string(255)
#  condition   :text
#  alternative :text
#  rule_id     :integer
#  priority    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

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

    # 
    # Returns an array containing all the parameters of the rule
    # 
    # @return [Array] The list of all the parameters of the rule
    def get_parameters_list
      rule.get_parameters_list
    end
  end
end
