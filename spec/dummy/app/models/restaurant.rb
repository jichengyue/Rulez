# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ActiveRecord::Base
  attr_accessible :city, :name

  def annullamenti_a_settimane
    3
  end
end
