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

require 'test_helper'

module Rulez
  class RuleTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
