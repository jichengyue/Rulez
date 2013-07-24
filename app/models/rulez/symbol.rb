# == Schema Information
#
# Table name: rulez_symbols
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Rulez
  class Symbol < ActiveRecord::Base
    attr_accessible :description, :name

    #associations
    has_and_belongs_to_many :context, join_table: :rulez_contexts_symbols

    #validations
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
  end
end
