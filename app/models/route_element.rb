class RouteElement < ActiveRecord::Base
  attr_accessible :real_distance, :real_d_elevation, :real_time_distance, :waypoint_start_id, :waypoint_finish_id, :url

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
