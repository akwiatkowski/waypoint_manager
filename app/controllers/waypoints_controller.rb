class WaypointsController < InheritedResources::Base
  has_scope :page, default: 1
  has_scope :area_id
end
