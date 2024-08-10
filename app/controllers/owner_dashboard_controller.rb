class OwnerDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant, only: [:show]
  before_action :set_orders, only: [:show]
  def index
    @restaurants = current_user.restaurants
  end

  def show;  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
    @menu_items = @restaurant.menu_items
  end

  def set_orders
    @active_orders = @restaurant.orders.where(status: ['pending', 'preparing'])
    @daily_orders = @restaurant.orders.where('created_at >= ?', 1.day.ago).count
  end

  def ensure_owner
    redirect_to root_path, alert: 'Access denied' unless current_user.owner?
  end
end
