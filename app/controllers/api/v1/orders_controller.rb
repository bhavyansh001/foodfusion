module Api
  module V1
    class OrdersController < BaseController
      def index
        @orders = current_user.orders
        render json: @orders, status: :ok
      end

      def show
        @order = find_order
        if @order
          render json: @order, status: :ok
        else
          render json: { error: 'Access denied' }, status: :forbidden
        end
      end

      def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @order = current_user.orders.new(restaurant: @restaurant)

        if process_order_items && @order.save
          render json: @order, status: :created
        else
          render json: { errors: @order.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def find_order
        order = Order.find(params[:id])
        return unless current_user == order.visitor || current_user == order.restaurant.owner
          order
      end

      def process_order_items
        return false unless params[:order_items].present?

        create_order_items
        calculate_total_price
        true
      end

      def create_order_items
        params[:order_items].each do |item|
          menu_item = MenuItem.find(item[:menu_item_id])
          @order.order_items.new(
            menu_item:,
            quantity: item[:quantity].to_i,
            price: menu_item.price
          )
        end
      end

      def calculate_total_price
        @order.total_price = @order.order_items
                                   .sum { |item| item.quantity * item.price }
      end
    end
  end
end
