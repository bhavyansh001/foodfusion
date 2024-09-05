require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }
  let(:valid_headers) { { 'Authorization' => "Bearer #{user.api_token}" } }

  describe 'GET /api/v1/orders' do
    before do
      create_list(:order, 3, visitor: user)
      get '/api/v1/orders', headers: valid_headers
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all orders for the current user' do
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/orders/:id' do
    let(:order) { create(:order, visitor: user) }

    before do
      get "/api/v1/orders/#{order.id}", headers: valid_headers
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct order' do
      expect(JSON.parse(response.body)['id']).to eq(order.id)
    end

    context 'when the order does not belong to the current user' do
      let(:another_user) { create(:user) }
      let(:order) { create(:order, visitor: another_user) }

      before do
        get "/api/v1/orders/#{order.id}", headers: valid_headers
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('Access denied')
      end
    end
  end

  describe 'POST /api/v1/restaurants/:restaurant_id/add_order' do
    let(:valid_attributes) do
      {
        restaurant_id: restaurant.id,
        order_items: [
          { menu_item_id: menu_items.first.id, quantity: 2 }
        ]
      }
    end

    context 'with valid parameters' do
      before do
        post "/api/v1/restaurants/#{restaurant.id}/add_order", params: valid_attributes, headers: valid_headers
      end

      it 'creates a new Order' do
        expect(Order.count).to eq(1)
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created order' do
        expect(JSON.parse(response.body)['id']).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          restaurant_id: restaurant.id,
          order_items: [
            { menu_item_id: 'invalid_id', quantity: 2 }
          ]
        }
      end

      before do
        post "/api/v1/restaurants/#{restaurant.id}/add_order", params: invalid_attributes, headers: valid_headers
      end

      it 'does not create a new Order' do
        expect(Order.count).to eq(0)
      end

      it 'returns an not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
