class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name, :sym
  # default_scope order: 'created_at ASC'


  def google_maps_path(map_zoom = 15)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}"
  end

  def alt
    elevation
  end

end
