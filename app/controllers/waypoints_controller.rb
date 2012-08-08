class WaypointsController < InheritedResources::Base
  load_and_authorize_resource

  has_scope :page, default: 1, if: Proc.new{ |r| r.request.format == 'html'}
  has_scope :area_id
  has_scope :private
  has_scope :public
  has_scope :sorted, as: :sort

  respond_to :gpx, :xml, :json, :csv
end
