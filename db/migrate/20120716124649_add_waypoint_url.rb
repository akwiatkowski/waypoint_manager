class AddWaypointUrl < ActiveRecord::Migration
  def change
    add_column :waypoints, :url, :string, null: true, default: nil
  end
end
