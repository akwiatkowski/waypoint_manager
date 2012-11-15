FactoryGirl.define do
  factory :route_element do
    association :route
    association :waypoint
  end
end


