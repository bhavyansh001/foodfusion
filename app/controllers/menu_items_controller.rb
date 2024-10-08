class MenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner
  before_action :set_restaurant
  before_action :set_menu_item, only: %i[edit update destroy]

  def new
    @menu_item = @restaurant.menu_items.new
  end

  def create
    @menu_item = build_menu_item

    respond_to do |format|
      if @menu_item.save
        format.turbo_stream
        format.html { redirect_to_dashboard('Menu item was successfully created.') }
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
          redirect_to_dashboard('Menu item was successfully updated.')
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
        redirect_to_dashboard('Menu item was successfully destroyed.')
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

    redirect_to root_path, alert: 'Access denied.'
  end

  def build_menu_item
    @restaurant.menu ||= @restaurant.create_menu
    @restaurant.menu_items.new(menu_item_params).tap do |item|
      item.menu_id = @restaurant.menu.id
    end
  end

  def redirect_to_dashboard(notice)
    redirect_to dashboard_path(@restaurant), notice:
  end
end
