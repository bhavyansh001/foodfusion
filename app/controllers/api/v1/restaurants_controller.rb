module Api
  module V1
    class RestaurantsController < BaseController
      def index
        @restaurants = Restaurant.all
        render json: @restaurants
      end

      def show
        @restaurant = Restaurant.find(params[:id])
        render json: @restaurant
      end
    end
  end
end
