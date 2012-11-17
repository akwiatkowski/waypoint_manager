class AddAreaTypes2 < ActiveRecord::Migration
  def up
    AreaType.create(name: "Mountains", sym: "Summit")
    AreaType.create(name: "Cities", sym: "Building")
    AreaType.create(name: "Countryside", sym: "Residence")
  end

  def down
  end
end
