class Route < ActiveRecord::Base
  attr_accessible :name, :url, :area_id
  has_many :route_elements
  belongs_to :area
  belongs_to :user

  validates_presence_of :area

  # Total route distance
  def distance
    _d = 0
    self.route_elements.each do |route_element|
      if route_element.real_distance
        _d += route_element.real_distance
      else
        _d += route_element.distance
      end
    end
    return _d
  end

  def time_distance
    _d = 0
    self.route_elements.each do |route_element|
      _d += route_element.real_time_distance.to_i
    end
    return _d
  end

  def time_distance_human
    td = time_distance
    h = (td / 60).floor
    m = td - h * 60
    return "#{h}:#{"%.2d" % m}"
  end

  # Create route map
  def to_png(zoom = 12)
    require 'gpx2png/osm'
    require 'RMagick'
    e = Gpx2png::Osm.new
    e.renderer = :rmagick
    e.renderer_options = { aa: false, opacity: 0.5, color: '#0000FF', crop_enabled: true }

    coords = Array.new
    self.route_elements.each do |re|
      coords << re.start
      coords << re.finish
    end
    coords = coords.map{|c| {lat: c.lat, lon: c.lon}}

    e.coords = coords
    e.zoom = zoom
    e.to_png
  end

end
