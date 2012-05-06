class Area < ActiveRecord::Base
  attr_accessible :area_type, :name
  has_many :waypoints
end
