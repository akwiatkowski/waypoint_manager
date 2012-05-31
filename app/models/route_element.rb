class RouteElement < ActiveRecord::Base
  belongs_to :route
  belongs_to :start, foreign_key: 'waypoint_start_id', class_name: 'Waypoint'
  belongs_to :finish, foreign_key: 'waypoint_finish_id', class_name: 'Waypoint'

  before_save :distance

  # Recalculate distance
  def calculate_distance
    self.start.distance_to(self.finish)
  end

  def distance
    self.distance = calculate_distance
    super
  end
end
