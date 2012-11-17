class AddAreaTypes < ActiveRecord::Migration
  def change
    create_table :area_types do |t|
      t.string :name
      t.string :sym

      t.timestamps
    end
  end
end
