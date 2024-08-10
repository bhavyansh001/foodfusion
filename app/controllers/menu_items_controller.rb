class MenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant
  before_action :set_menu_item, only: [:edit, :update, :destroy]
  def new
    @menu_item = @restaurant.menu_items.new
  end

  def create
    @menu_item = @restaurant.menu_items.new(menu_item_params)
    @menu_item.menu_id = @restaurant.menu.id
    if @menu_item.save
      redirect_to dashboard_path(@restaurant),
        notice: 'Menu item was successfully created.'
    else
      render :new
    end
  end

  def edit;  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to dashboard_path(@restaurant),
        notice: 'Menu item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to dashboard_path(@restaurant),
      notice: 'Menu item was successfully deleted.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = @restaurant.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :availability)
  end

  def ensure_owner
    redirect_to root_path,
      alert: 'Access denied.' unless current_user.owner?
  end
end
