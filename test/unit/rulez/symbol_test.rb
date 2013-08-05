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

require 'test_helper'

module Rulez
  class SymbolTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
