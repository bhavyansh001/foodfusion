class RestaurantsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @menu = Restaurant.find(params[:id]).menu
    @menu_items = @menu.menu_items
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
