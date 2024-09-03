FactoryBot.define do
  factory :restaurant do
    association :owner, factory: [:user, :owner]
    name { Faker::Restaurant.name }
  end
end
