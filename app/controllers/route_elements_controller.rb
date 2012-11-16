class RouteElementsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :route, optional: true
  has_scope :page, default: 1, if: Proc.new { |r| r.request.format == 'html' }
  belongs_to :route

  def continue
    # TODO remove it
  end

  def create
    super do |format|
      format.html { redirect_to route_route_element_path(resource.route, resource)}
    end
  end

  def update
    super do |format|
      format.html { redirect_to route_route_element_path(resource.route, resource)}
    end
  end

end
