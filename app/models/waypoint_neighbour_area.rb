class WaypointNeighbourArea < ActiveRecord::Base
  attr_accessible []
  belongs_to :waypoint
  belongs_to :area
end