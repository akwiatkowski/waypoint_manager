class RemoveNeighbourArea < ActiveRecord::Migration
  def up
    drop_table :waypoint_neighbour_areas
  end

  def down
  end
end
