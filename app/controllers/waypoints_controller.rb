class WaypointsController < InheritedResources::Base
  has_scope :page
  before_filter :maintain_page_number
end
