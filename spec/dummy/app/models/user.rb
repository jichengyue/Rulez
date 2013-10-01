class User < ActiveRecord::Base
  attr_accessible :age, :name

  belongs_to :favorite_city, :class_name => 'City'
end
