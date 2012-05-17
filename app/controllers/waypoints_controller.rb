class WaypointsController < InheritedResources::Base
  has_scope :page, default: 1
  has_scope :area_id
  has_scope :private
  has_scope :public

  respond_to :gpx, :xml, :json, :csv
end
