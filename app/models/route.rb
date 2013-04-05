class Route < ActiveRecord::Base
  attr_accessible :name, :url, :area_id
  has_many :route_elements
  belongs_to :area
  belongs_to :user
  belongs_to :last_route_element, foreign_key: 'last_route_element_id', class_name: 'RouteElement'

  validates_presence_of :area, :name

  # TODO add height chart using
  # http://nvd3.org/ghpages/line.html

  # Total route distance
  def distance
    _d = 0
    self.route_elements.each do |route_element|
      if route_element.real_distance
        _d += route_element.real_distance
      else
        _d += route_element.distance.to_f
      end
    end
    return _d
  end

  def d_elevation
    _d = 0
    self.route_elements.each do |route_element|
      if route_element.real_d_elevation
        _d += route_element.real_d_elevation.to_f.abs
      else
        _d += route_element.d_elevation.to_f.abs
      end
    end
    return _d
  end

  def time_distance
    _d = 0
    self.route_elements.each do |route_element|
      if route_element.real_time_distance
        _d += route_element.real_time_distance
      else
        _d += route_element.time_distance.to_i
      end
    end
    return _d
  end

  def self.time_distance_human(minutes)
    h = (minutes / 60).floor
    m = minutes - h * 60
    return "#{h}:#{"%.2d" % m}"
  end

  def time_distance_human
    return self.class.time_distance_human(time_distance)
  end

  # Create route map
  def to_png_zoomed(zoom = 12)
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
    coords = coords.map { |c| { lat: c.lat, lon: c.lon } }

    e.coords = coords
    e.zoom = zoom
    e.to_png
  end

  def to_png(_options = { })
    _width = _options[:width] || 1200
    _height = _options[:height] || 800
    _width = _width.to_i
    _height = _height.to_i

    _zoom = _options[:zoom] || 13
    _zoom = _zoom.to_i

    _osm = _options[:osm] || false

    _zoom = 8 if _zoom < 8
    _zoom = 16 if _zoom > 16

    if user.can? :draw_super_big_map, Route
      _width = 2000 if _width > 8000
      _height = 1500 if _height > 600
    elsif user.can? :draw_normal_big_map, Route
      _width = 2000 if _width > 2000
      _height = 1500 if _height > 1500
    else
      _width = 2000 if _width > 1000
      _height = 1500 if _height > 500
    end


    require 'RMagick'
    if _osm
      require 'gpx2png/osm'
      e = Gpx2png::Osm.new
    else
      require 'gpx2png/ump'
      e = Gpx2png::Ump.new
    end
    e.renderer = :rmagick
    e.renderer_options = { aa: true, opacity: 0.5, color: '#0000FF', crop_enabled: true }

    unless _options[:coords]
      coords = Array.new
      self.route_elements.each do |re|
        coords << re.waypoint
      end
      coords = coords.map { |c| { lat: c.lat, lon: c.lon } }
    else
      coords = _options[:coords]
    end
    e.coords = coords

    # markers
    self.waypoints.each_with_index do |w, i|
      e.add_marker(
        label: "(#{i+1}) #{w.name} (#{w.elevation}m)",
        lat: w.lat,
        lon: w.lon
      )
    end

    e.fixed_size(_width, _height)
    puts _width, _height, "*" * 1000
    #e.zoom = _zoom # tmp. disabled
    e.to_png
  end

  #def waypoints
  #  self.route_elements.collect { |re| re.waypoint }
  #end

  has_many :waypoints, through: :route_elements

  def sw_lat
    return nil if self.waypoints.empty?
    self.waypoints.order("lat ASC").first.lat - Waypoint::PANORAMIO_NEAR
  end

  def ne_lat
    return nil if self.waypoints.empty?
    self.waypoints.order("lat DESC").first.lat + Waypoint::PANORAMIO_NEAR
  end

  def sw_lon
    return nil if self.waypoints.empty?
    self.waypoints.order("lon ASC").first.lon - Waypoint::PANORAMIO_NEAR
  end

  def ne_lon
    return nil if self.waypoints.empty?
    self.waypoints.order("lon DESC").first.lon + Waypoint::PANORAMIO_NEAR
  end

  def geojson
    # http://www.interoperate.co.uk/blog/2012/02/07/using-openlayers-with-rails/
    coordinates = self.route_elements.collect { |e| [e.waypoint.lon, e.waypoint.lat] }

    # return a GeoJSON 'FeatureCollection'
    { type: "FeatureCollection",
      features: [
        type: "Feature",
        geometry: {
          type: "GeometryCollection",
          geometries: [
            { type: "LineString", coordinates: coordinates }
          ]
        }
      ]
    }
  end

end
