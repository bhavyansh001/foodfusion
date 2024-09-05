require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }
  let(:order) { create(:order, visitor: user, restaurant:) }
  let(:menu_item) { create(:menu_item, menu: restaurant.menu) }

  before do
    sign_in user
    restaurant.menu = create(:menu)
  end

  describe 'GET #show' do
    it 'assigns the requested order to @order' do
      get :show, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'PATCH #update_status' do
    context 'with valid params' do
      it 'updates the order status' do
        patch :update_status, params: { id: order.id, status: 'confirmed' }
        expect(order.reload.status).to eq('confirmed')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'raises an ArgumentError for invalid status' do
        expect do
          patch :update_status, params: { id: order.id, status: 'invalid_status' }
        end.to raise_error(ArgumentError, "'invalid_status' is not a valid status")
      end
    end
  end

  describe 'POST #add_order' do
    let(:valid_params) do
      {
        restaurant_id: restaurant.id,
        menu_item_ids: [menu_item.id],
        quantities: { menu_item.id.to_s => '2' }
      }
    end

    context 'with valid params' do
      it 'creates a new order' do
        expect do
          post :add_order, params: valid_params
        end.to change(Order, :count).by(1)
      end

      it 'redirects to the created order' do
        post :add_order, params: valid_params
        expect(response).to redirect_to(Order.last)
      end
    end

    context 'with invalid params' do
      it 'redirects to restaurant page when no menu items are selected' do
        post :add_order, params: { restaurant_id: restaurant.id }
        expect(response).to redirect_to(restaurant)
        expect(flash[:alert]).to eq('No menu items selected.')
      end
    end
  end

  describe 'private methods' do
    describe '#find_restaurant' do
      it 'returns the correct restaurant' do
        allow(controller).to receive(:params).and_return({ restaurant_id: restaurant.id })
        expect(controller.send(:find_restaurant)).to eq(restaurant)
      end
    end

    describe '#build_order' do
      it 'builds a new order for the current user' do
        allow(controller).to receive(:current_user).and_return(user)
        controller.instance_variable_set(:@restaurant, restaurant)
        expect(controller.send(:build_order).visitor).to eq(user)
        expect(controller.send(:build_order).restaurant).to eq(restaurant)
      end
    end

    describe '#calculate_total_price' do
      it 'calculates the correct total price' do
        order_items = [
          build(:order_item, quantity: 2, price: 10),
          build(:order_item, quantity: 1, price: 15)
        ]
        expect(controller.send(:calculate_total_price, order_items)).to eq(35)
      end
    end
    describe '#ensure_correct_visitor' do
      let(:owner) { create(:user) }
      let(:restaurant) { create(:restaurant, owner:) }
      let(:order) { create(:order, visitor: user, restaurant:) }
      let(:another_user) { create(:user) }

      before do
        sign_in user
        allow(controller).to receive(:params).and_return({ id: order.id })
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      context 'when the current user is the visitor of the order' do
        let(:current_user) { user }

        it 'allows access' do
          get :show, params: { id: order.id }
          expect(response).to have_http_status(:success)
        end
      end

      context 'when the current user is the owner of the restaurant associated with the order' do
        let(:current_user) { owner }

        it 'allows access' do
          get :show, params: { id: order.id }
          expect(response).to have_http_status(:success)
        end
      end

      context 'when the current user is neither the visitor nor the owner' do
        let(:current_user) { another_user }

        it 'denies access and redirects to root path' do
          get :show, params: { id: order.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Access denied')
        end
      end
    end
  end
end
