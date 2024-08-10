class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_owner, except: [:show]
  before_action :set_restaurant_instance,
                 only: [:edit, :update, :destroy]
  def new
    @restaurant = current_user.restaurants.build
  end

  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    if @restaurant.save
      redirect_to owner_dashboard_index_path,
        notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @menu_items = @restaurant.menu_items
  end

  def edit;  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to owner_dashboard_index_path,
        notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to owner_dashboard_index_path,
      notice: 'Restaurant was successfully deleted.'
  end

  private

  def set_restaurant_instance
    @restaurant = current_user.restaurants.find(params[:id])
  end
  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def ensure_owner
    redirect_to root_path,
      alert: 'Access denied.' unless current_user.owner?
  end
end
