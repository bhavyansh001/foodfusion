FactoryBot.define do
  factory :menu_item do
    menu
    name { "Example Item" }
    description { "An example menu item" }
    price { 9.99 }
    availability { :available }
  end
end
