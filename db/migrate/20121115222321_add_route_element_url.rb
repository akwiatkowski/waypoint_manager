class AddRouteElementUrl < ActiveRecord::Migration
  def change
    add_column :route_elements, :url, :string
  end
end
