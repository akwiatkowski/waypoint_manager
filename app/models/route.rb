class Route < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :route_elements
  belongs_to :area
end
