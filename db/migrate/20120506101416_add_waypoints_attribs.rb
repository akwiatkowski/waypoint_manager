class AddWaypointsAttribs < ActiveRecord::Migration
  def change
    add_column :waypoints, :imported_at, :datetime
    add_column :waypoints, :sym, :string
  end
end
