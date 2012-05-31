FactoryGirl.define do
  factory :route do
    sequence(:name) { |n| "route_" + n.to_s }
  end
end


