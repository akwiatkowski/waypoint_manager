class AddAreaAvgLatAvgLon < ActiveRecord::Migration
  def change
    add_column :areas, :avg_lat, :float
    add_column :areas, :avg_lon, :float
  end
end
