class OrdersController < ApplicationController
  include RestaurantConcern

  def show
    @order = Order.find(params[:id])
  end

  def add_order
    @restaurant = Restaurant.find(params[:restaurant_id])
    @selected_menu_item_ids = params[:menu_item_ids]
    @quantities = params[:quantities]

    @order = current_user.orders.new(restaurant: @restaurant)

    if @selected_menu_item_ids.present?
      @selected_menu_item_ids.each do |menu_item_id|
        menu_item = MenuItem.find(menu_item_id)
        quantity = @quantities[menu_item_id].to_i
        @order.order_items.new(menu_item: menu_item, quantity: quantity, price: menu_item.price)
      end

      @order.total_price = @order.order_items.sum { |item| item.quantity * item.price }

      if @order.save
        redirect_to @order, notice: 'Order created successfully.'
      else
        redirect_to @restaurant, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'No menu items selected.'
      redirect_to @restaurant
    end
  end
end
