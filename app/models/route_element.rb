class RouteElement < ActiveRecord::Base
  attr_accessible :real_distance, :real_d_elevation, :real_time_distance, :waypoint_id, :url

  belongs_to :route
  belongs_to :waypoint
  belongs_to :previous_route_element, foreign_key: 'previous_route_element_id', class_name: 'RouteElement'
  belongs_to :next_route_element, foreign_key: 'next_route_element_id', class_name: 'RouteElement'

  before_save :distance

  validates_presence_of :waypoint, :route

  after_initialize :assign_previous

  def assign_previous
    self.previous_route_element_id ||= self.route.last_route_element_id
  end

  after_create :assign_last_route_element_id

  def assign_last_route_element_id
    a = self.route.last_route_element_id
    b = self.id

    if a.nil? or a < b
      self.route.last_route_element_id = b
      self.route.save!
    end

    # assign next
    if not a.nil? and not a == b
      rn = RouteElement.find(a)
      rn.next_route_element_id = b
      rn.save!
    end
  end

  ## Recalculate distance
  #def calculate_distance
  #  return nil if self.start.nil? or self.finish.nil?
  #  self.start.distance_to(self.finish)
  #end
  #
  #def calculate_elevation
  #  return nil if self.start.nil? or self.finish.nil?
  #  self.finish.elevation - self.start.elevation
  #end
  #
  #def distance
  #  self.distance = calculate_distance
  #  super
  #end
  #
  #def d_elevation
  #  self.d_elevation = calculate_elevation
  #  super
  #end

  def time_distance
    _d = self.real_distance.nil? ? self.distance : self.real_distance
    _h = self.real_d_elevation.nil? ? self.d_elevation : self.real_d_elevation

    return nil if _d.nil? or _h.nil?

    _td = ((60.0 * _d.to_f / 1000.0) / 4.0).ceil
    _th = (_h.abs.to_f / 100.0 * 10.0).ceil

    return _td + _th
  end

  def google_url
    "https://maps.google.com/maps?saddr=#{self.start.lat},#{self.start.lon}&daddr=#{self.finish.lat},#{self.finish.lon}"
  end

  def is_first_on_route?
    self.previous_route_element.nil?
  end

  def possible_next_waypoint
    if is_first_on_route?
      # all waypoints from area
      return self.route.area.waypoints
    else
      # get all near waypoints
      _previous_waypoint = self.previous_route_element.waypoint
      _near_waypoints = Waypoint.near(_previous_waypoint).all
      # add distance
      _near_waypoints.each do |w|
        w.tmp_distance = w.distance_to(_previous_waypoint)
      end
      # and sort
      return _near_waypoints.sort { |a, b| a.tmp_distance <=> b.tmp_distance }
    end
  end
end
