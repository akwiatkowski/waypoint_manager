class AddRouteLastRouteElementId < ActiveRecord::Migration
  def change
    add_column :routes, :last_route_element_id, :integer
  end
end
