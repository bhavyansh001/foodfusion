class MenuItem < ApplicationRecord
  belongs_to :menu
  has_many :order_items
  has_many :orders, through: :order_items
  enum availability: { available: 0, out_of_stock: 1 }
end
