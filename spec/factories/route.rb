FactoryGirl.define do
  factory :route do
    sequence(:name) { |n| "route_" + n.to_s }
    association :area
  end
end


