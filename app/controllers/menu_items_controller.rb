class MenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant
  before_action :set_menu_item, only: %i[edit update destroy]
  def new
    @menu_item = @restaurant.menu_items.new
  end

  def create
    @restaurant.menu ||= @restaurant.create_menu
    @menu_item = @restaurant.menu_items.new(menu_item_params)
    @menu_item.menu_id = @restaurant.menu.id
    respond_to do |format|
      if @menu_item.save
        format.turbo_stream
        format.html do
          redirect_to dashboard_path(@restaurant),
                      notice: 'Menu item was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @menu_item.update(menu_item_params)
        format.turbo_stream
        format.html do
          redirect_to dashboard_path(@restaurant),
                      notice: 'Menu item was successfully updated.'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @menu_item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to dashboard_path(@restaurant),
                    notice: 'Menu item was successfully destroyed.'
      end
    end
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
    return if current_user.owner?

    redirect_to root_path,
                alert: 'Access denied.'
  end
end
