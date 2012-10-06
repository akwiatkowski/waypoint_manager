class Area < ActiveRecord::Base
  attr_accessible :area_type, :name
  has_many :waypoints, order: :name
  has_many :waypoint_neighbour_areas, through: :waypoints
  has_many :neighbour_areas, through: :waypoint_neighbour_areas, source: :area
  #has_many :neighbour_waypoints, through: :neighbour_areas, source: :waypoint

  TYPES = {
    "Mountains" => Waypoint::SYMBOLS["Summit"],
    "Cities" => Waypoint::SYMBOLS["Building"],
    "Countryside" => Waypoint::SYMBOLS["Residence"]
  }

  def img_symbol
    TYPES[area_type] || ''
  end

end