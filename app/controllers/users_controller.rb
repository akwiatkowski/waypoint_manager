class UsersController < InheritedResources::Base
  has_scope :page, default: 1, if: Proc.new{ |r| r.request.format == 'html'}
  respond_to :xml, :json, :csv

  def export
    authorize! :export, resource
    render json: WaypointMigrator.export(resource)
  end

  def import

  end

  def import_payload

  end
end
