class RouteElement < ActiveRecord::Base
  attr_accessible :real_distance, :real_d_elevation, :real_time_distance, :waypoint_start_id, :waypoint_finish_id

  belongs_to :route
  belongs_to :start, foreign_key: 'waypoint_start_id', class_name: 'Waypoint'
  belongs_to :finish, foreign_key: 'waypoint_finish_id', class_name: 'Waypoint'

  before_save :distance

  validates_presence_of :start, :finish, :route

  USE_GEO_DISTANCE = true

  # Recalculate distance
  def calculate_distance
    return nil if self.start.nil? or self.finish.nil?
    self.start.distance_to(self.finish)
  end

  def calculate_elevation
    return nil if self.start.nil? or self.finish.nil?
    self.finish.elevation - self.start.elevation
  end

  def distance
    self.distance = calculate_distance
    super
  end

  def d_elevation
    self.d_elevation = calculate_elevation
    super
  end

  # List of waypoints for new route element: all from area or finish
  # waypoint from last route element
  def continue_waypoints_start
    if self.start.nil?
      last_route_element = self.route.route_elements.last
      if last_route_element
        # creating new element, it should has only finish from last element
        return [last_route_element.finish]
      else
        # creating first element
        return self.route.area.waypoints.order(:name)
      end
    else
      # editing, maintaining start
      return [self.start]
    end
  end

  # List of waypoints for new route element: all from area or all except
  # finish waypoint from last route element with proper order
  def continue_waypoints_finish
    last_route_element = self.route.route_elements.last
    if last_route_element
      # last waypoint
      _last_finish = last_route_element.finish

      if USE_GEO_DISTANCE
        # within lat/lon distance
        _all_waypoints = Waypoint.near(_last_finish).all
      else
        # waypoints from similar area + neighbours
        _all_waypoints = _last_finish.area.waypoints + _last_finish.neighbour_waypoints
      end

      # remove
      _all_waypoints -= [_last_finish] unless self.finish == _last_finish

      # add distance
      _all_waypoints.each do |w|
        w.tmp_distance = w.distance_to(self.start)
      end

      # and sort
      _all_waypoints = _all_waypoints.sort { |a, b| a.tmp_distance <=> b.tmp_distance }

      return _all_waypoints

    else
      return self.route.area.waypoints
    end
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
end
