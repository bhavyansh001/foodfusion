FactoryBot.define do
  factory :order_item do
    order
    menu_item
    quantity { 1 }
  end
end
