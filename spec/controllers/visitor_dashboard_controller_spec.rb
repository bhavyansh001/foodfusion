require 'rails_helper'

RSpec.describe VisitorDashboardController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'when user is authenticated' do
      before do
        sign_in user
        create_list(:order, 3, visitor: user, status: 'pending')
        create_list(:order, 2, visitor: user, status: 'confirmed')
        create_list(:order, 4, visitor: user, status: 'completed')
        create_list(:order, 1, visitor: user, status: 'cancelled')
      end

      it 'assigns @active_orders' do
        get :show
        expect(assigns(:active_orders).count).to eq(5)
        expect(assigns(:active_orders).pluck(:status)).to all(be_in(%w[pending confirmed in_progress]))
      end

      it 'assigns @order_history' do
        get :show
        expect(assigns(:order_history).count).to eq(5)
        expect(assigns(:order_history).pluck(:status)).to all(be_in(%w[completed cancelled]))
      end

      it 'renders the show template' do
        get :show
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the sign in page' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
