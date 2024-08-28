class OrderStatusUpdateMailerJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    OrderMailer.status_update(order).deliver_now
  end
end
