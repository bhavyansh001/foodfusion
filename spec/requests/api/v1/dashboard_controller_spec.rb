require 'rails_helper'

RSpec.describe Api::V1::DashboardController, type: :request do
  let(:owner) { create(:user, role: 'owner') }
  let(:visitor) { create(:user, role: 'visitor') }
  let(:restaurant) { create(:restaurant, owner:) }

  describe 'GET #show' do
    context 'when user is an owner' do
      before do
        allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(owner)
        get '/api/v1/dashboard', headers: { 'Authorization' => "Bearer #{owner.api_token}" }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns owner dashboard data' do
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('restaurants')
        expect(json_response['restaurants']).to be_an(Array)
      end
    end

    context 'when user is a visitor' do
      before do
        allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(visitor)
        get '/api/v1/dashboard', headers: { 'Authorization' => "Bearer #{visitor.api_token}" }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns visitor dashboard data' do
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('active_orders')
        expect(json_response).to have_key('order_history')
      end
    end
  end
end
