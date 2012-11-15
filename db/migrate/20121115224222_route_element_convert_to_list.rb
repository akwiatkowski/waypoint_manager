class RouteElementConvertToList < ActiveRecord::Migration
  def change
    # :(
    Route.delete_all
    RouteElement.delete_all

    rename_column :route_elements, :waypoint_start_id, :waypoint_id
    add_column :route_elements, :next_route_element_id, :integer
    add_column :route_elements, :previous_route_element_id, :integer
    remove_column :route_elements, :waypoint_finish_id
  end
end
