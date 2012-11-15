class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name, :sym, :area_id, :is_private, :dms_coords, :url
  belongs_to :area
  has_many :route_elements
  belongs_to :user
  has_many :waypoint_neighbour_areas
  has_many :neighbour_areas, through: :waypoint_neighbour_areas, source: :area
  has_many :neighbour_waypoints, through: :neighbour_areas, source: :waypoints

  GEO_NEAR = 0.1
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

  # http://stackoverflow.com/questions/639171/what-is-causing-this-activerecordreadonlyrecord-error
  #default_scope lambda { order(:created_at).joins("LEFT JOIN `areas` ON waypoints.area_id = areas.id") }
  #default_scope lambda { order(:created_at).includes(:area) }
  default_scope lambda { includes(:area) }

  # Temporary distance used in continuing route
  attr_accessor :tmp_distance

  # Used in continuing route to display distance to next waypoint
  def collection_label
    _str = self.name
    if @tmp_distance
      _str += " (#{tmp_distance})"
    end
    return _str
  end

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon

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

  def google_maps_path(map_zoom = 13)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}&t=p"
  end

  def ump_path(map_zoom = 13)
    "http://mapa.ump.waw.pl/ump-www/?zoom=#{map_zoom}&lat=#{lat}&lon=#{lon}&mlat=#{lat}&mlon=#{lon}"
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

  def imported?
    not imported_at.nil?
  end

  def lat_short
    "%.4f" % lat
  end

  def lon_short
    "%.4f" % lon
  end

end
