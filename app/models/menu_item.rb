class MenuItem < ApplicationRecord
  belongs_to :menu
  enum availability: { available: 0, out_of_stock: 1 }
end
