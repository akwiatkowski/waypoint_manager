class AddWaypointsPhone < ActiveRecord::Migration
  def change
    add_column :waypoints, :phone, :string
    add_column :waypoints, :email, :string
    add_column :waypoints, :official_url, :string
  end
end
