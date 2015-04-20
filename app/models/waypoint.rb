class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name, :sym, :area_id, :is_private, :dms_coords, :url, :official_url, :phone, :email
  belongs_to :area
  has_many :route_elements
  belongs_to :user

  after_create :update_area_avg_lat_lon

  validates_presence_of :name, :lat, :lon

  def update_area_avg_lat_lon
    self.area.update_avg_lat_lon! if self.area
  end

  GEO_NEAR = 0.3
  # http://www.panoramio.com/api/widget/api.html
  PANORAMIO_NEAR = 0.005

  scope :near, lambda { |_w|
    where(["lat between ? and ? and lon between ? and ?",
           _w.lat - GEO_NEAR,
           _w.lat + GEO_NEAR,
           _w.lon - GEO_NEAR,
           _w.lon + GEO_NEAR
          ]) }

  scope :area_id, lambda { |_area_id| where(area_id: _area_id) }
  scope :wo_area, lambda { where(area_id: nil) }
  scope :is_private, lambda { where(is_private: true) }
  scope :is_public, lambda { where(is_private: false) }
  scope :sym, lambda { |_sym| where(sym: _sym) }

  # http://stackoverflow.com/questions/639171/what-is-causing-this-activerecordreadonlyrecord-error
  #default_scope lambda { order(:created_at).joins("LEFT JOIN `areas` ON waypoints.area_id = areas.id") }
  #default_scope lambda { order(:created_at).includes(:area) }
  default_scope lambda { includes(:area) }

  # Temporary distance used in continuing route
  attr_accessor :tmp_distance, :tmp_direction

  # Used in continuing route to display distance to next waypoint
  def collection_label
    _str = self.name
    if @tmp_distance
      _str += " (#{tmp_distance}km"
      if @tmp_direction
        _str += " " + @tmp_direction
      end
      _str += ")"
    end
    return _str
  end

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon

  # http://freegeographytools.com/2008/garmin-gps-unit-waypoint-icons-table
  SYMBOLS = {
    "Residence" => "residence1.gif", # towns, villages, cities, ...
    "Lodging" => "lodging3.gif", # rooms, beds, place to sleep, mountain hus
    "Trail Head" => "trail-head1.gif", # other trail parts, not summits
    "Summit" => "summit1.gif", # top of mountain
    "Scenic Area" => "scenic-area1.gif", # for an awesome photos, or any other interesting part of track
    "Picnic Area" => "picnic-area1.gif", # any "light hiking" places

    "Building" => "building1.gif",
    "Church" => "church1.gif",
    "Cemetery" => "cemetery1.gif",

    "Restaurant" => "restaurant5.gif", # any place to eat
    "Shopping" => "shopping3.gif",

    "Ground Transportation" => "ground-transportation1.gif", # all public ground transportation stops

    "Flag, Blue" => "blue-flag1.gif",
    "Flag, Green" => "green-flag1.gif",
    "Flag, Red" => "red-flag1.gif",

    "Pin, Blue" => "blue-pin1.gif",
    "Pin, Green" => "green-pin1.gif",
    "Pin, Red" => "red-pin1.gif",

    #"Block, Blue",
    #"Block, Green",
    #"Block, Red",
  }

  def google_maps_path(map_zoom = 13)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}&t=p"
  end

  def ump_path(map_zoom = 13)
    "http://mapa.ump.waw.pl/ump-www/?zoom=#{map_zoom}&lat=#{lat}&lon=#{lon}&mlat=#{lat}&mlon=#{lon}"
  end

  def osm_path(map_zoom = 13, type = nil)
    s = "http://www.openstreetmap.org/#map=#{map_zoom}/#{lat}/#{lon}"
    s += "&layers=#{type}" if type
    s
  end

  def cycle_map_path(map_zoom = 13)
    osm_path(map_zoom, "C")
  end

  def transport_map_path(map_zoom = 13)
    osm_path(map_zoom, "T")
  end

  def mapquest_path(map_zoom = 13)
    osm_path(map_zoom, "Q")
  end

  def humanitarian_map_path(map_zoom = 13)
    osm_path(map_zoom, "H")
  end

  def alt
    elevation
  end

  # image symbol used for current waypoint
  def img_symbol
    SYMBOLS[sym] || ''
  end

  # http://stackoverflow.com/questions/1317178/parsing-latitude-and-longitude-with-ruby
  def dms_coords=(dms_pair)
    c = dms_pair.scan(/(-?\d+\.*\d*)\D*/).flatten
    if c.size == 4
      c = c[0..1] + [0] + c[2..3] + [0]
    end

    if c.size == 6
      self.lat = self.class.dms_to_degrees(*c[0..2].map { |x| x.to_f })
      self.lon = self.class.dms_to_degrees(*c[3..5].map { |x| x.to_f })
    end
  end

  def dms_coords
    # TODO someday
    nil
  end

  def self.dms_to_degrees(d, m, s)
    degrees = d
    fractional = m / 60 + s / 3600
    if d > 0
      degrees + fractional
    else
      degrees - fractional
    end
  end

  def distance_to(_waypoint)
    return nil if _waypoint.nil?
    self_geo = Geokit::LatLng.new(self.lat, self.lon)
    other_geo = Geokit::LatLng.new(_waypoint.lat, _waypoint.lon)
    (self_geo.distance_to(other_geo, units: :kms) * 1000.0).ceil
  end

  def waypoints_withing
    ws = Waypoint.all
    ws = ws - [self]
    ws.each do |w|
      w.tmp_distance = self.distance_to(w)
    end
    ws.sort! { |a, b| a.tmp_distance <=> b.tmp_distance }
    ws
  end

  def heading_to(_waypoint)
    return nil if _waypoint.nil? or _waypoint == self
    begin
      self_geo = Geokit::LatLng.new(self.lat, self.lon)
      other_geo = Geokit::LatLng.new(_waypoint.lat, _waypoint.lon)
      self_geo.heading_to(other_geo)
    rescue => e
      Rails.logger.error("heading_to from #{self.inspect} to #{_waypoint.inspect}, error #{e.inspect}")
      return nil
    end
  end

  def heading_to_human(_waypoint)
    h = heading_to(_waypoint)
    return nil if h.nil?

    h += 22.5
    h = h.round
    h %= 360
    h /= 45.0
    h = h.floor

    h = case h
          when 0 then
            "N"
          when 1 then
            "NE"
          when 2 then
            "E"
          when 3 then
            "SE"
          when 4 then
            "S"
          when 5 then
            "SW"
          when 6 then
            "W"
          when 7 then
            "NW"
          else
            "error"
        end

    return h.to_s
  end

  def imported?
    not imported_at.nil?
  end

  def lat_short
    "%.4f" % lat
  end

  def lon_short
    "%.4f" % lon
  end

  def sw_lat
    self.lat - PANORAMIO_NEAR
  end

  def ne_lat
    self.lat + PANORAMIO_NEAR
  end

  def sw_lon
    self.lon - PANORAMIO_NEAR
  end

  def ne_lon
    self.lon + PANORAMIO_NEAR
  end

  def sunrise_sunset(date = Date.today)
    calc = SolarEventCalculator.new(date, BigDecimal.new(self.lat.to_s), BigDecimal.new(self.lon.to_s))

    d = {
      sunrise: {
        civil: begin
          calc.compute_utc_civil_sunrise.to_time.localtime rescue nil
        end,
        official: begin
          calc.compute_utc_official_sunrise.to_time.localtime rescue nil
        end,
        nautical: begin
          calc.compute_utc_nautical_sunrise.to_time.localtime rescue nil
        end,
        astronomical: begin
          calc.compute_utc_astronomical_sunrise.to_time.localtime rescue nil
        end,
      },
      sunset: {
        civil: begin
          calc.compute_utc_civil_sunset.to_time.localtime rescue nil
        end,
        official: begin
          calc.compute_utc_official_sunset.to_time.localtime rescue nil
        end,
        nautical: begin
          calc.compute_utc_nautical_sunset.to_time.localtime rescue nil
        end,
        astronomical: begin
          calc.compute_utc_astronomical_sunset.to_time.localtime rescue nil
        end,
      },
      date: date
    }
  end

  def get_sunrise_sunset_data
    res = Array.new
    d = Date.today
    (0...10).each do |i|
      res << sunrise_sunset(d + i)
    end

    return res
  end

  def get_sun_degrees
    res = Array.new
    calc = SolarEventCalculator.new(Date.today, BigDecimal.new(self.lat.to_s), BigDecimal.new(self.lon.to_s))

    (0..55).each do |d|
      degree = d * 2
      ta = calc.convert_to_datetime(calc.compute_utc_solar_event(degree, true))
      tb = calc.convert_to_datetime(calc.compute_utc_solar_event(degree, false))

      ta = ta.to_time.localtime if ta
      tb = tb.to_time.localtime if tb

      res << {
        degree: (90 - degree),
        first: ta,
        last: tb
      } if ta or tb
    end

    #return calc
    return res
  end

  def get_degrees_by_time
    data = get_sun_degrees

    time_data = Array.new
    i = 0
    i_max = 24*3 # 24 hours, divide hour for 3 blocks

    while i < i_max
      time_offset = i * 20.minutes
      time_data << {
        time: Time.now.beginning_of_day + time_offset,
        degree: nil
      }

      i += 1
    end

    time_data.each do |td|
      selected = data.select { |d| d[:first] and td[:time] and d[:last] and d[:first] <= td[:time] and d[:last] >= td[:time] }
      selected.each do |s|
        s[:offset_first] = td[:time] - s[:first]
        s[:offset_last] = s[:last] - td[:time]
        s[:offset] = s[:offset_first] > s[:offset_last] ? s[:offset_last] : s[:offset_first]
      end

      # sort
      selected = selected.sort { |a, b| a[:offset] <=> b[:offset] }

      td[:count] = selected.size
      if td[:count] > 0
        td[:degree] = selected.first[:degree]
      end

    end

    return time_data

  end

  def golden_hours(date = Date.today, type = :official)
    # "The ‘golden hours’ for most types of landscape photography occur between  roughly 30 minutes before and about an hour-and-a-half after sunrise in  the morning and between about an hour-and-a-half before sunset and up  to an hour after the sun has gone down."
    ss_data = sunrise_sunset(date)
    h = Hash.new

    h[:sunrise_from] = ss_data[:sunrise][type] - 30.minutes
    h[:sunrise_to] = ss_data[:sunrise][type] + 90.minutes

    h[:sunset_from] = ss_data[:sunset][type] - 90.minutes
    h[:sunset_to] = ss_data[:sunset][type] + 60.minutes

    return h
  end

  def weather_urls
    return [
      #{ name: "weather.gov", url: "http://forecast.weather.gov/MapClick.php?lat=#{self.lat}&lon=#{self.lon}" }
      { name: "Weather", url: "http://api.openweathermap.org/data/2.5/weather?lat=#{self.lat}&lon=#{self.lon}&mode=html" }
    ]
  end

end
