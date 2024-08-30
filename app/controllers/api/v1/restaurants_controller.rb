module Api
  module V1
    class RestaurantsController < BaseController
      def index
        @restaurants = Restaurant.all
        render json: @restaurants
      end
    end
  end
end
