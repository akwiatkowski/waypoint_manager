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

  TYPE_IMAGES_NAMES = [
    "Mountains",
    "Cities",
    "Countryside",
  ]

  default_scope order(:id)

  def img_symbol
    Waypoint::SYMBOLS[self.sym] || ''
  end
end