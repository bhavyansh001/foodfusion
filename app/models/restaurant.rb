class Restaurant < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_one :menu, dependent: :destroy
  has_many :orders, dependent: :destroy
end
