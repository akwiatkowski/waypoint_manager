class AddRouteElementRealTimeDistance < ActiveRecord::Migration
  def change
    # distance in minutes
    add_column :route_elements, :real_time_distance, :integer, null: true, default: nil
  end
end
