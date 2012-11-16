class RouteElement < ActiveRecord::Base
  attr_accessible :real_distance, :real_d_elevation, :real_time_distance, :waypoint_id, :url

  belongs_to :route
  belongs_to :waypoint
  belongs_to :previous_route_element, foreign_key: 'previous_route_element_id', class_name: 'RouteElement'
  belongs_to :next_route_element, foreign_key: 'next_route_element_id', class_name: 'RouteElement'

  before_save :distance

  validates_presence_of :waypoint, :route

  after_create :update_route_last_route_element_id

  def update_route_last_route_element_id
    if self.route.last_route_element
      self.class.join_elements(self.route.last_route_element_id, self.id)
      self.reload
      # self.previous_route_element.reload
    end

    self.route.last_route_element_id = self.route.route_elements.last.id
    self.route.save!
  end

  def self.join_elements(previous_id, next_id)
    p = find(previous_id)
    n = find(next_id)

    n.previous_route_element_id ||= previous_id
    p.next_route_element_id ||= next_id
    n.save!
    p.save!
  end


  # Recalculate distance
  def calculate_distance
    return nil if self.previous_route_element.nil?
    self.waypoint.distance_to(self.previous_route_element.waypoint)
  end

  def calculate_elevation
    return nil if self.previous_route_element.nil?
    self.waypoint.elevation - self.previous_route_element.waypoint.elevation
  end

  def distance
    self.distance = calculate_distance
    super
  end

  def d_elevation
    self.d_elevation = calculate_elevation
    super
  end

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

  def previous_or_last
    if self.new_record?
      self.route.last_route_element
    else
      self.previous_route_element
    end
  end

  def is_first_on_route?
    previous_or_last.nil?
  end

  def possible_next_waypoint
    if is_first_on_route?
      # all waypoints from area
      return self.route.area.waypoints
    else
      # get all near waypoints
      _previous_waypoint = self.previous_or_last.waypoint
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
