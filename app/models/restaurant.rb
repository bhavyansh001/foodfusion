class Restaurant < ApplicationRecord
  include RestaurantAnalytics

  validates :name, presence: true

  belongs_to :owner, class_name: 'User'
  has_one :menu, dependent: :destroy
  has_many :menu_items, through: :menu
  has_many :orders, dependent: :destroy

  broadcasts_to ->(_restaurant) { 'restaurants' }, inserts_by: :append
end
