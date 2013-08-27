# == Schema Information
#
# Table name: rulez_rules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  rule        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  context_id  :integer
#

module Rulez

  # 
  # Defines a rule.
  # 
  class Rule < ActiveRecord::Base
    attr_accessible :description, :name, :rule, :context_id, :parameters

    #associations
    belongs_to :context
    has_many :alternatives, dependent: :destroy

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :rule, presence: true, syntax: true
    validates :context, presence: true
    validates :parameters, parameters: true

    def get_parameters_list
      parameters.split(',').map{|p| p.strip}
    end
  end
end
