class AddRoutePrivateFlag < ActiveRecord::Migration
  def change
    add_column :routes, :private, :boolean, default: false, null: false
  end
end
