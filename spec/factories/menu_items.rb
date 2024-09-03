FactoryBot.define do
  factory :menu_item do
    menu
    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 5.0..30.0) }
    availability { :available }
  end
end
