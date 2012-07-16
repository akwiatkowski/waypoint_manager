class AddWaypointOwner < ActiveRecord::Migration
  def change
    add_column :waypoints, :user_id, :integer
    add_column :routes, :user_id, :integer
  end
end
