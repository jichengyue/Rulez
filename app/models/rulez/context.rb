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
  class Context < ActiveRecord::Base
    attr_accessible :description, :name

    has_many :rules
    has_and_belongs_to_many :symbols, join_table: :rulez_contexts_symbols
  end
end
