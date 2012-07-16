class AddUserAdminFlag < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
