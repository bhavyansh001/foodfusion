require 'rails_helper'

RSpec.describe OwnerDashboardController, type: :controller do
  let(:owner) { create(:user, :owner) }
  let(:restaurant) { create(:restaurant, owner:) }

  describe 'before actions' do
    it 'requires authentication' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'requires owner role' do
      user = create(:user)
      sign_in user
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied')
    end
  end

  describe 'GET #index' do
    before do
      sign_in owner
    end

    it 'assigns @restaurants' do
      restaurants = create_list(:restaurant, 3, owner:)
      get :index
      expect(assigns(:restaurants)).to match_array(restaurants)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before do
      sign_in owner
      restaurant.menu = create(:menu)
      create_list(:order, 5, restaurant:)
      menu_items = create_list(:menu_item, 10, menu: restaurant.menu)

      completed_orders = create_list(:order, 2, restaurant: restaurant, status: 'completed')
      completed_orders.each do |order|
      menu_items.each do |item|
        create(:order_item, order: order, menu_item: item, quantity: 2, price: 10)
      end
    end

      allow_any_instance_of(Restaurant).to receive(:total_revenue).and_return(1000)
      allow_any_instance_of(Restaurant).to receive(:average_order_value).and_return(20)
      allow_any_instance_of(Restaurant).to receive(:revenue_by_day).and_return({ Date.today => 100 })
    end

    it 'assigns instance variables' do
      get :show, params: { restaurant_id: restaurant.id }

      expect(assigns(:restaurant)).to eq(restaurant)
      expect(assigns(:menu_items)).to eq(restaurant.menu_items)
      expect(assigns(:active_orders)).to be_present
      expect(assigns(:daily_orders)).to be_present
      expect(assigns(:total_revenue)).to eq(1000)
      expect(assigns(:average_order_value)).to eq(20)
      expect(assigns(:revenue_by_day)).to eq({ Date.today => 100 })
      expect(assigns(:top_items)).to be_present
      expect(assigns(:highest_revenue_items)).to be_present
      expect(assigns(:order_status_distribution)).to be_present
      expect(assigns(:total_customers)).to be_present
      expect(assigns(:returning_customers)).to be_present
      expect(assigns(:peak_hours)).to be_present
      expect(assigns(:menu_item_availability)).to be_present
    end

    it 'renders the show template' do
      get :show, params: { restaurant_id: restaurant.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'private methods' do
    before do
      sign_in owner
      @controller.params = { restaurant_id: restaurant.id }
      @controller.instance_variable_set(:@restaurant, restaurant)
    end

    it '#set_restaurant finds the correct restaurant' do
      @controller.send(:set_restaurant)
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it '#set_orders sets active and daily orders' do
      create_list(:order, 3, restaurant:, status: 'pending')
      create_list(:order, 2, restaurant:, status: 'in_progress')
      create(:order, restaurant:, status: 'completed', created_at: 2.days.ago)

      @controller.send(:set_orders)
      expect(assigns(:active_orders).count).to eq(5)
      expect(assigns(:daily_orders)).to eq(5)
    end

    it '#set_revenue_analytics sets revenue-related variables' do
      allow(restaurant).to receive(:total_revenue).and_return(1000)
      allow(restaurant).to receive(:average_order_value).and_return(20)
      allow(restaurant).to receive(:revenue_by_day).and_return({ Date.today => 100 })

      @controller.send(:set_revenue_analytics)
      expect(assigns(:total_revenue)).to eq(1000)
      expect(assigns(:average_order_value)).to eq(20)
      expect(assigns(:revenue_by_day)).to eq({ Date.today => 100 })
    end

    it '#set_popular_items sets popular items variables' do
      top_items = double('top_items')
      highest_revenue_items = double('highest_revenue_items')

      allow(restaurant).to receive(:top_items).and_return(top_items)
      allow(restaurant).to receive(:highest_revenue_items).and_return(highest_revenue_items)

      @controller.send(:set_popular_items)
      expect(assigns(:top_items)).to eq(top_items)
      expect(assigns(:highest_revenue_items)).to eq(highest_revenue_items)
    end

    it '#set_order_status_distribution sets the order status distribution' do
      allow(restaurant).to receive_message_chain(:orders, :group,
                                                 :count).and_return({ 'pending' => 5, 'completed' => 3 })

      @controller.send(:set_order_status_distribution)
      expect(assigns(:order_status_distribution)).to eq({ 'pending' => 5, 'completed' => 3 })
    end

    it '#set_customer_analytics sets customer analytics variables' do
      total_customers = double('total_customers')
      returning_customers = double('returning_customers')

      allow(restaurant).to receive(:total_customers).and_return(total_customers)
      allow(restaurant).to receive(:returning_customers).and_return(returning_customers)

      @controller.send(:set_customer_analytics)
      expect(assigns(:total_customers)).to eq(total_customers)
      expect(assigns(:returning_customers)).to eq(returning_customers)
    end

    it '#set_peak_hours sets peak hours' do
      peak_hours = double('peak_hours')

      allow(restaurant).to receive_message_chain(:orders, :group_by_hour_of_day, :count).and_return(peak_hours)

      @controller.send(:set_peak_hours)
      expect(assigns(:peak_hours)).to eq(peak_hours)
    end

    it '#set_menu_item_availability sets menu item availability' do
      menu_item_availability = double('menu_item_availability')

      allow(restaurant).to receive_message_chain(:menu_items, :group, :count).and_return(menu_item_availability)

      @controller.send(:set_menu_item_availability)
      expect(assigns(:menu_item_availability)).to eq(menu_item_availability)
    end
  end
end
