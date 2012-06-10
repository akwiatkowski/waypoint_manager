class RouteElement < ActiveRecord::Base
  attr_accessible :real_distance, :real_d_elevation, :real_time_distance, :waypoint_start_id, :waypoint_finish_id

  belongs_to :route
  belongs_to :start, foreign_key: 'waypoint_start_id', class_name: 'Waypoint'
  belongs_to :finish, foreign_key: 'waypoint_finish_id', class_name: 'Waypoint'

  before_save :distance

  # Recalculate distance
  def calculate_distance
    self.start.distance_to(self.finish)
  end

  def calculate_elevation
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
    last_route_element = self.route.route_elements.last
    if last_route_element
      return [last_route_element.finish]
    else
      return self.route.area.waypoints.order(:name)
    end
  end

  # List of waypoints for new route element: all from area or all except
  # finish waypoint from last route element with proper order
  def continue_waypoints_finish
    last_route_element = self.route.route_elements.last
    if last_route_element
      _last_finish = last_route_element.finish
      _all_waypoints = self.route.area.waypoints

      # remove
      _all_waypoints -= [_last_finish]

      # add distance
      _all_waypoints.each do |w|
        w.tmp_distance = w.distance_to(_last_finish)
      end

      # and sort
      _all_waypoints = _all_waypoints.sort{|a,b| a.tmp_distance <=> b.tmp_distance}

      return _all_waypoints

    else
      return self.route.area.waypoints
    end
  end

  def google_url
    "https://maps.google.com/maps?saddr=#{self.start.lat},#{self.start.lon}&daddr=#{self.finish.lat},#{self.finish.lon}"
  end
end
