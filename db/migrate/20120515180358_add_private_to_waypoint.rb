class AddPrivateToWaypoint < ActiveRecord::Migration
  def change
    add_column :waypoints, :private, :boolean, default: false, null: false
  end
end
