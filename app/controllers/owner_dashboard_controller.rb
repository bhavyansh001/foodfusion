class OwnerDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant, only: [:show]
  before_action :set_orders, only: [:show]

  def index
    @restaurants = current_user.restaurants
  end

  def show
    set_revenue_analytics
    set_popular_items
    set_order_status_distribution
    set_customer_analytics
    set_peak_hours
    set_menu_item_availability
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
    @menu_items = @restaurant.menu_items
  end

  def set_orders
    @active_orders = @restaurant.orders.where(status: %w[pending preparing])
    @daily_orders = @restaurant.orders.where('created_at >= ?', 1.day.ago).count
  end

  def set_revenue_analytics
    @total_revenue = @restaurant.total_revenue
    @average_order_value = @restaurant.average_order_value
    @revenue_by_day = @restaurant.revenue_by_day
  end

  def set_popular_items
    @top_items = @restaurant.top_items
    @highest_revenue_items = @restaurant.highest_revenue_items
  end

  def set_order_status_distribution
    @order_status_distribution = @restaurant.orders.group(:status).count
  end

  def set_customer_analytics
    @total_customers = @restaurant.total_customers
    @returning_customers = @restaurant.returning_customers
  end

  def set_peak_hours
    @peak_hours = @restaurant.orders.group_by_hour_of_day(:created_at).count
  end

  def set_menu_item_availability
    @menu_item_availability = @restaurant.menu_items.group(:availability).count
  end

  def ensure_owner
    redirect_to root_path, alert: 'Access denied' unless current_user.owner?
  end
end
