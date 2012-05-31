class CreateRouteElements < ActiveRecord::Migration
  def change
    create_table :route_elements do |t|
      t.integer :waypoint_start_id, null: false
      t.integer :waypoint_finish_id, null: false

      t.integer :distance
      t.integer :d_elevation

      t.references :route

      t.timestamps
    end

    add_column :routes, :area_id, :integer
  end
end
