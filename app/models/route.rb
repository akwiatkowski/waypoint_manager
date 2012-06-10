class Route < ActiveRecord::Base
  attr_accessible :name, :url, :area_id
  has_many :route_elements
  belongs_to :area

  validates_presence_of :area
end
