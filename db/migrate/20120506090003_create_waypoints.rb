class CreateWaypoints < ActiveRecord::Migration
  def change
    create_table :waypoints do |t|
      t.float :lat
      t.float :lon
      t.integer :elevation
      t.string :name

      t.timestamps
    end
  end
end
