class AddRouteRealValues < ActiveRecord::Migration
  def change
    add_column :route_elements, :real_distance, :integer, null: true, default: nil
    add_column :route_elements, :real_d_elevation, :integer, null: true, default: nil
  end
end
