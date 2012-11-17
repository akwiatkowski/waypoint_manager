class AreaType < ActiveRecord::Base
  attr_accessible :name, :sym
  has_many :areas, order: :name

  TYPES = [
    "Mountains",
    "Cities",
    "Countryside"
  ]

  TYPE_IMAGES = [
    Waypoint::SYMBOLS["Summit"],
    Waypoint::SYMBOLS["Building"],
    Waypoint::SYMBOLS["Residence"]
  ]

  default_scope order(:id)

  def img_symbol
    TYPE_IMAGES[self.id] || ''
  end
end