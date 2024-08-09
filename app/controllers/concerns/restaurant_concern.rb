module RestaurantConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_restaurant
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
