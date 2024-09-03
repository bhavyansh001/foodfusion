FactoryBot.define do
  factory :order_item do
    order
    menu_item
    quantity { Faker::Number.between(from: 1, to: 5) }
    price { menu_item.price }
  end
end
