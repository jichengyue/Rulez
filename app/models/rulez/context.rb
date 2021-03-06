# == Schema Information
#
# Table name: rulez_contexts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Rulez

  # 
  # A context defines a set of variables and functions that can be referenced and evaluated by rules.
  # A rule must be associated with a context for using its variables and functions.
  # All variables that are not defined in that context are considered invalid.
  # 
  class Context < ActiveRecord::Base
    # attr_accessible :description, :name, :variable_ids

    #associations
    has_many :rules
    has_and_belongs_to_many :variables, join_table: :rulez_contexts_variables

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence:true
  end
end
