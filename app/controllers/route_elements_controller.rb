class RouteElementsController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :route

  def continue
    @route = Route.find(params[:route_id])
    @last_route_element = @route.route_elements.last
    new!
  end
end
