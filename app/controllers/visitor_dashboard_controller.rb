class VisitorDashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @active_orders = current_user.orders
                                 .where(status: %w[pending confirmed in_progress])
    @order_history = current_user.orders
                                 .where(status: %w[completed cancelled])
                                 .order(created_at: :desc).limit(10)
  end
end
