class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def add_order
    @restaurant = find_restaurant
    @order = build_order
    return redirect_to @restaurant,
           alert: 'No menu items selected.' unless order_items_params_present?

    process_order_items
    save_order
  end

  private

  def find_restaurant
    Restaurant.find(params[:restaurant_id])
  end

  def build_order
    current_user.orders.new(restaurant: @restaurant)
  end

  def process_order_items
    build_order_items(@order,
                      params[:menu_item_ids],
                      params[:quantities])
    @order.total_price = calculate_total_price(@order.order_items)
  end

  def save_order
    if @order.save
      redirect_to @order, notice: 'Order created successfully.'
    else
      redirect_to @restaurant, status: :unprocessable_entity
    end
  end

  def order_items_params_present?
    params[:menu_item_ids].present?
  end

  def build_order_items(order, menu_item_ids, quantities)
    menu_item_ids.each do |id|
      order.order_items.new(menu_item: MenuItem.find(id),
                            quantity: quantities[id].to_i,
                            price: MenuItem.find(id).price)
    end
  end

  def calculate_total_price(order_items)
    order_items.sum { |item| item.quantity * item.price }
  end

  def order_params
    params.permit(menu_item_ids: [], quantities: {})
  end
end
