class Area < ActiveRecord::Base
  attr_accessible :area_type, :name
  has_many :waypoints, order: :name
  has_many :waypoint_neighbour_areas, through: :waypoints
  has_many :neighbour_areas_via_waypoints, through: :waypoint_neighbour_areas, source: :area
  has_many :neighbour_waypoints_via_waypoints, through: :neighbour_areas_via_waypoints, source: :waypoints

  before_save :update_avg_lat_lon

  TYPES = {
    "Mountains" => Waypoint::SYMBOLS["Summit"],
    "Cities" => Waypoint::SYMBOLS["Building"],
    "Countryside" => Waypoint::SYMBOLS["Residence"]
  }

  scope :ordered, order(:name)

  def img_symbol
    TYPES[area_type] || ''
  end

  def update_avg_lat_lon
    if self.waypoints.count > 0
      self.avg_lat = self.waypoints.average(:lat)
      self.avg_lon = self.waypoints.average(:lon)
    end
    return self
  end

end