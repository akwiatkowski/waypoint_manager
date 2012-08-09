class RoutePrivateRenameToIsPrivate < ActiveRecord::Migration
  def up
    rename_column :routes, :private, :is_private
  end

  def down
    rename_column :routes, :is_private, :private
  end
end
