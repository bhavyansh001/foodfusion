class OwnerDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant, only: [:show]
  before_action :set_orders, only: [:show]

  include OwnerDashboardHelper

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
    @total_revenue = total_revenue(@restaurant)
    @average_order_value = average_order_value(@restaurant)
    @revenue_by_day = revenue_by_day(@restaurant)
  end

  def set_popular_items
    @top_items = top_items(@restaurant)
    @highest_revenue_items = highest_revenue_items(@restaurant)
  end

  def set_order_status_distribution
    @order_status_distribution = @restaurant.orders.group(:status).count
  end

  def set_customer_analytics
    @total_customers = total_customers(@restaurant)
    @returning_customers = returning_customers(@restaurant)
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
