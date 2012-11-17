class ChangeAreaTypes < ActiveRecord::Migration
  def change
    add_column :areas, :area_type_id, :integer
    Area.all.each do |a|
      if a.area_type == "Mountains"
        a.area_type_id = 1
      elsif a.area_type == "Cities"
        a.area_type_id = 2
      elsif a.area_type == "Countryside"
        a.area_type_id = 2
      end
      a.save!
    end
    remove_column :areas, :area_type
  end
end
