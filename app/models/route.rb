class Route < ActiveRecord::Base
  attr_accessible :name, :url, :area_id
  has_many :route_elements
  belongs_to :area

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
      if route_element.real_distance
        _d += route_element.real_distance
      else
        _d += route_element.distance
      end
    end
    return _d
  end
end
