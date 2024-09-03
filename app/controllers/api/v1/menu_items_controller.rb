module Api
  module V1
    class MenuItemsController < BaseController
      before_action :set_restaurant

      def index
        @menu_items = @restaurant.menu_items
        render json: @menu_items
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      end
    end
  end
end
