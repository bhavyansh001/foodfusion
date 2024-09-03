require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  describe 'POST #create' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    context 'with valid credentials' do
      before { post '/api/v1/login', params: { email: 'test@example.com', password: 'password' } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user token and email' do
        json_response = JSON.parse(response.body)
        expect(json_response).to include('token', 'email')
        expect(json_response['email']).to eq('test@example.com')
      end
    end

    context 'with invalid credentials' do
      before { post '/api/v1/login', params: { email: 'test@example.com', password: 'wrong_password' } }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
