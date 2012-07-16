class Waypoint < ActiveRecord::Base
  attr_accessible :elevation, :lat, :lon, :name, :sym, :area_id, :private, :dms_coords
  belongs_to :area
  has_many :route_elements
  belongs_to :user

  scope :area_id, lambda { |_area_id| where(area_id: _area_id) }
  scope :private, lambda { |v| where(private: true) }
  scope :public, lambda { |v| where(private: false) }

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

  def google_maps_path(map_zoom = 15)
    "http://maps.google.com/maps?q=#{lat},#{lon}&z=#{map_zoom}&t=p"
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
    return unless c.size == 6

    self.lat = self.class.dms_to_degrees(*c[0..2].map { |x| x.to_f })
    self.lon = self.class.dms_to_degrees(*c[3..5].map { |x| x.to_f })
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
    self_geo = Geokit::LatLng.new(self.lat, self.lon)
    other_geo = Geokit::LatLng.new(_waypoint.lat, _waypoint.lon)
    (self_geo.distance_to(other_geo) * 1000.0).ceil
  end

end
