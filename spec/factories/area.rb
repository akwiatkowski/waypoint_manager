FactoryGirl.define do
  factory :area do
    sequence(:name) { |n| "area_" + n.to_s }
    area_type Area::TYPES.keys.sample
  end
end


