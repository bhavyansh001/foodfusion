FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    role { :visitor }

    trait :owner do
      role { :owner }
    end
  end
end
