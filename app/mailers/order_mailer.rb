class OrderMailer < ApplicationMailer
  def status_update(order)
    @order = order
    mail(to: @order.visitor.email, subject: "Order Status Update")
  end
end
