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

    _width = 2000 if _width > 2000
    _height = 1500 if _height > 1500

    require 'RMagick'
    if _osm
      require 'gpx2png/osm'
      e = Gpx2png::Osm.new
    else
      require 'gpx2png/ump'
      e = Gpx2png::Ump.new
    end
    e.renderer = :rmagick
    e.renderer_options = { aa: false, opacity: 0.5, color: '#0000FF', crop_enabled: true }

    coords = Array.new
    self.route_elements.each do |re|
      coords << re.start
      coords << re.finish
    end
    coords = coords.map { |c| { lat: c.lat, lon: c.lon } }

    e.coords = coords
    e.fixed_size(_width, _height)
    puts _width, _height, "*" * 1000
    #e.zoom = _zoom # tmp. disabled
    e.to_png
  end

end
