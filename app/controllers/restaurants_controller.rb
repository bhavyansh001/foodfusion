class RestaurantsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @menu_items = @restaurant.menu_items
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
