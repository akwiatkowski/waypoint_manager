class RouteElementsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :route, optional: true
  has_scope :page, default: 1, if: Proc.new { |r| r.request.format == 'html' }
  belongs_to :route

  def continue
    @route = Route.find(params[:route_id])
    @last_route_element = @route.route_elements.last
    new!
  end
end
