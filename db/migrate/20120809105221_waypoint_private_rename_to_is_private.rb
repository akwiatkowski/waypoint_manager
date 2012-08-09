class WaypointPrivateRenameToIsPrivate < ActiveRecord::Migration
  def up
    rename_column :waypoints, :private, :is_private
  end

  def down
    rename_column :waypoints, :is_private, :private
  end
end
