class WaypointsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :area, optional: true

  has_scope :page, default: 1, if: Proc.new{ |r| r.request.format == 'html'}
  has_scope :area_id
  has_scope :wo_area
  has_scope :is_private
  has_scope :is_public
  has_scope :sym
  has_scope :sorted, as: :sort

  respond_to :gpx, :xml, :json, :csv
end
