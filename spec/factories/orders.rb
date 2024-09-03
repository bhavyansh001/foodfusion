FactoryBot.define do
  factory :order do
    association :visitor, factory: :user
    restaurant
    status { :pending }
    total_price { Faker::Commerce.price(range: 10.0..100.0) }

    trait :with_items do
      transient do
        items_count { 3 }
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.items_count, order: order)
        order.update(total_price: order.order_items.sum { |item| item.quantity * item.menu_item.price })
      end
    end
  end
end
