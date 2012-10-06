class CreateWaypointNeighbourAreas < ActiveRecord::Migration
  def change
    create_table :waypoint_neighbour_areas do |t|
      t.integer :waypoint_id
      t.integer :area_id
      
      t.timestamps
    end
  end
end
