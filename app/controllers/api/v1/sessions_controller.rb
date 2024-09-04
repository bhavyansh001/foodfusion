module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_api_request, only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          render json: { token: user.api_token, email: user.email }
        else
          render json: { error: 'Invalid email or password' },
                 status: :unauthorized
        end
      end
    end
  end
end
