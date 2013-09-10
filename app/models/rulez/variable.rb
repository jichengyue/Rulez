# == Schema Information
#
# Table name: rulez_variables
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  model       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Rulez

  # 
  # A variable is a variable name that is guaranteed to be referenceable and evaluable.
  # Defining variables allows to design rules that directly reference and evaluate application objects.
  # 
  class Variable < ActiveRecord::Base
    attr_accessible :description, :name, :model

    #associations
    has_and_belongs_to_many :context, join_table: :rulez_contexts_variables

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    validates :model, presence: true, model_existence: true
    
  end
end
