require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController, type: :request do
  let(:user) { create(:user) }
  let!(:restaurants) { create_list(:restaurant, 3) }

  before do
    allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    before { get '/api/v1/restaurants', headers: { 'Authorization' => "Bearer #{user.api_token}" } }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all restaurants' do
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:restaurant) { restaurants.first }

    before { get "/api/v1/restaurants/#{restaurant.id}", headers: { 'Authorization' => "Bearer #{user.api_token}" } }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the requested restaurant' do
      expect(JSON.parse(response.body)['id']).to eq(restaurant.id)
    end
  end
end
