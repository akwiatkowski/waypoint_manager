class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name

  def google_maps_path(map_zoom = 12)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}"
  end

end
