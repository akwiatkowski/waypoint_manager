class WaypointsController < InheritedResources::Base
  has_scope :page, default: 1, if: Proc.new{ |r| r.request.format == 'html'}
  has_scope :area_id
  has_scope :private
  has_scope :public

  respond_to :gpx, :xml, :json, :csv
end
