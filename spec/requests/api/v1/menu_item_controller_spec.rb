require 'rails_helper'

RSpec.describe 'Api::V1::MenuItems', type: :request do
  let(:user) { create(:user, :owner, api_token: 'valid_api_token') }
  let(:restaurant) { create(:restaurant, owner: user) }
  let!(:menu) { create(:menu, restaurant:) }
  let!(:menu_items) { create_list(:menu_item, 3, menu:) }

  before do
    restaurant.menu = menu
  end

  describe 'GET /api/v1/restaurants/:restaurant_id/menu_items' do
    context 'with valid token' do
      before do
        get "/api/v1/restaurants/#{restaurant.id}/menu_items",
            headers: { 'Authorization' => "Bearer valid_api_token" }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the list of menu items' do
        # puts "Response body: #{response.body}"
        expect(json_response.size).to eq(3)
        expect(json_response.first['id']).to eq(menu_items.first.id)
      end
    end

    context 'with invalid token' do
      before do
        get "/api/v1/restaurants/#{restaurant.id}/menu_items",
            headers: { 'Authorization' => "Bearer invalid_token" }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
