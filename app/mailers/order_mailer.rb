class OrderMailer < ApplicationMailer
  def status_update(order)
    @order = order
    mail(to: @order.visitor.email, subject: I18n.t('email.order_status.subject'))
  end
end
