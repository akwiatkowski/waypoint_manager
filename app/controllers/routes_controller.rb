class RoutesController < InheritedResources::Base
  load_and_authorize_resource
  has_scope :page, default: 1, if: Proc.new { |r| r.request.format == 'html' }
  respond_to :png, :xml, :json, :csv, :geojson
  has_scope :sorted, as: :sort
end
