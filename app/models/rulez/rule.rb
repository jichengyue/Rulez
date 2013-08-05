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
    attr_accessible :description, :name, :rule, :context_id

    #associations
    belongs_to :context

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :rule, presence: true, syntax: true
    validates :context_id, presence: true
  end
end
