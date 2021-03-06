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

  validates :name,
            :presence => true

  has_many :users
  
  def annullamenti_a_settimana
    3
  end
end
