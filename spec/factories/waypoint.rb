FactoryGirl.define do
  factory :waypoint do
    lat 52.0
    lon 16.0
    elevation 200
    sequence(:name) { |n| "waypoint_" + n.to_s }
    sym Waypoint::SYMBOLS.keys.sample
    association :area
    private false
  end
end


