class Area < ActiveRecord::Base
  attr_accessible :area_type, :name
  has_many :waypoints, order: :name

  TYPES = {
    "Mountains" => Waypoint::SYMBOLS["Summit"],
    "Cities" => Waypoint::SYMBOLS["Building"],
    "Countryside" => Waypoint::SYMBOLS["Residence"]
  }

  def img_symbol
    TYPES[area_type] || ''
  end

end