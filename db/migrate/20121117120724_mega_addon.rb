class MegaAddon < ActiveRecord::Migration
  def change
    add_column :areas, :desc, :text
    add_column :areas, :url, :string
    add_column :areas, :photo_url, :string

    add_column :waypoints, :photo_url, :string
  end
end
