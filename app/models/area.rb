class Area < ActiveRecord::Base
  attr_accessible :area_type_id, :name
  has_many :waypoints, order: :name
  belongs_to :area_type

  before_save :update_avg_lat_lon

  scope :area_type_id, lambda { |_area_type_id| where(area_type_id: _area_type_id) }

  scope :ordered, order(:name)
  scope :horizontal, order("avg_lon ASC")
  delegate :name, to: :area_type, prefix: :area_type, allow_nil: true

  def img_symbol
    if self.area_type
      self.area_type.img_symbol
    else
      return ""
    end
  end

  def update_avg_lat_lon
    if self.waypoints.count > 0
      self.avg_lat = self.waypoints.average(:lat)
      self.avg_lon = self.waypoints.average(:lon)
    end
    return self
  end

  def update_avg_lat_lon!
    update_avg_lat_lon
    save!
  end

  #def area_type
  #  TYPES[self.area_type_id - 1]
  #end

end