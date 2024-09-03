require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :request do
  let(:user) { create(:user, api_token: 'valid_api_token') }

  describe '#authenticate_api_request' do
    context 'with valid token' do
      before do
        get '/api/v1/restaurants',
            headers: { 'Authorization' => "Bearer #{user.api_token}" }
      end

      it 'allows the request' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets the current_user' do
        expect(response).to be_successful
      end
    end

    context 'with invalid token' do
      before do
        get '/api/v1/restaurants',
            headers: { 'Authorization' => 'Bearer invalid_token' }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'without token' do
      before do
        get '/api/v1/restaurants'
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
      end
    end
  end
end
