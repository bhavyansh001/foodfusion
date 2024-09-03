class Order < ApplicationRecord
  enum status: {
    pending: 0,
    confirmed: 1,
    in_progress: 2,
    completed: 3,
    cancelled: 4
  }

  belongs_to :visitor, class_name: 'User'
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  broadcasts_to ->(order) { [order.restaurant, 'orders'] }
  after_update_commit :broadcast_status_update
  after_update :send_status_update_email, if: :saved_change_to_status?

  private

  def broadcast_status_update
    broadcast_replace_to [restaurant, 'orders'],
                         target: "order_#{id}_status",
                         partial: 'orders/status',
                         locals: { order: self }
  end

  def send_status_update_email
    OrderStatusUpdateMailerJob.perform_later(id)
  end
end
