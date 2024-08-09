class RestaurantsController < ApplicationController
  include RestaurantConcern
  def index
  end

  def new
  end

  def create
  end

  def show
    @menu = @restaurant.menu
    @menu_items = @menu.menu_items
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
