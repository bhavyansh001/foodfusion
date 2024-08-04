class Order < ApplicationRecord
  enum status: {
    pending: 0,
    confirmed: 1,
    in_progress: 2
    completed: 3,
    cancelled: 4
  }

  belongs_to :visitor, class_name: "User"
  belongs_to :restaurant
  has_many :order_items
end
