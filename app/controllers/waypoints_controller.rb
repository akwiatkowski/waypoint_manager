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

  def sunrise_sunset
    @sunrise = resource.get_sunrise_sunset_data
    @degrees = resource.get_sun_degrees
    @hourly = resource.get_degrees_by_time
    @golden_hours = resource.golden_hours
  end
end
