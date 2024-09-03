require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do
  describe 'POST #create' do
    let(:valid_attributes) { { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password' } } }
    let(:invalid_attributes) { { user: { email: 'test@example.com', password: 'password', password_confirmation: 'wrong_password' } } }

    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post '/api/v1/register', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post '/api/v1/register', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('token', 'email')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post '/api/v1/register', params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors' do
        post '/api/v1/register', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end
end
