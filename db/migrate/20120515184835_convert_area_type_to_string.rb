class ConvertAreaTypeToString < ActiveRecord::Migration
  def change
    change_column :areas, :area_type, :string
  end
end
