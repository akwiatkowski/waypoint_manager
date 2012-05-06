class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.integer :area_type

      t.timestamps
    end

    add_column :waypoints, :area_id, :integer
  end
end
