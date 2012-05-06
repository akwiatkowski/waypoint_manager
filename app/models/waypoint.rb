class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name, :sym

  #scope :page, lambda { |_page| page(_page) }

  # http://freegeographytools.com/2008/garmin-gps-unit-waypoint-icons-table
  SYMBOLS = {
    "Flag, Blue" => "blue-flag1.gif",
    "Flag, Green" => "green-flag1.gif",
    "Flag, Red" => "red-flag1.gif",

    "Pin, Blue" => "blue-pin1.gif",
    "Pin, Green" => "green-pin1.gif",
    "Pin, Red" => "red-pin1.gif",

    #"Block, Blue",
    #"Block, Green",
    #"Block, Red",

    "Summit" => "summit1.gif",
    "Trail Head" => "trail-head1.gif", # other trail parts, not summits
    "Lodging" => "lodging3.gif", # rooms, beds, place to sleep
    "Restaurant" => "restaurant5.gif", # any place to eat
    "Shopping" => "shopping3.gif",

    "Picnic Area" => "picnic-area1.gif", # any "light hiking" places
    "Scenic Area" => "scenic-area1.gif", # for an awesome photos

    "Residence" => "residence1.gif", # towns, villages, ...
    "Building" => "building1.gif",
    "Church" => "church1.gif",
    "Cemetery" => "cemetery1.gif",

    "Ground Transportation" => "ground-transportation1.gif" # all public ground transportation
  }

  def google_maps_path(map_zoom = 15)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}"
  end

  def alt
    elevation
  end

  # image symbol used for current waypoint
  def img_symbol
    SYMBOLS[sym] || ''
  end

end
