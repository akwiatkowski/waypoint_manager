FactoryGirl.define do
  factory :route_element do
    association :start, factory: :waypoint
    association :finish, factory: :waypoint
  end
end


