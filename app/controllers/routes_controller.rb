class RoutesController < InheritedResources::Base
  #has_scope :page, default: 1, if: Proc.new{ |r| r.request.format == 'html'}
end
