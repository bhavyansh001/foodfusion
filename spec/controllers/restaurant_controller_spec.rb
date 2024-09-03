require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let(:owner) { create(:user, :owner) }
  let(:restaurant) { create(:restaurant, owner: owner) }

  before do
    sign_in owner
  end

  describe 'GET #new' do
    it 'assigns a new restaurant to @restaurant' do
      get :new
      expect(assigns(:restaurant)).to be_a_new(Restaurant)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new restaurant' do
        expect {
          post :create, params: { restaurant: attributes_for(:restaurant) }
        }.to change(Restaurant, :count).by(1)
      end

      it 'redirects to the owner dashboard' do
        post :create, params: { restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to(owner_dashboard_index_path)
      end

      it 'associates the restaurant with the current user' do
        post :create, params: { restaurant: attributes_for(:restaurant) }
        expect(Restaurant.last.owner).to eq(owner)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new restaurant' do
        expect {
          post :create, params: { restaurant: attributes_for(:restaurant, name: nil) }
        }.to_not change(Restaurant, :count)
      end

      it 're-renders the new method' do
        post :create, params: { restaurant: attributes_for(:restaurant, name: nil) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let!(:menu) { create(:menu, restaurant: restaurant) }
    let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }

    it 'assigns the requested restaurant to @restaurant' do
      get :show, params: { id: restaurant.id }
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it 'assigns the restaurant menu items to @menu_items' do
      get :show, params: { id: restaurant.id }
      expect(assigns(:menu_items)).to match_array(menu_items)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested restaurant to @restaurant' do
      get :edit, params: { id: restaurant.id }
      expect(assigns(:restaurant)).to eq(restaurant)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the restaurant' do
        patch :update, params: { id: restaurant.id, restaurant: attributes_for(:restaurant, name: 'New Name') }
        restaurant.reload
        expect(restaurant.name).to eq('New Name')
      end

      it 'redirects to the owner dashboard' do
        patch :update, params: { id: restaurant.id, restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to(owner_dashboard_index_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the restaurant' do
        patch :update, params: { id: restaurant.id, restaurant: attributes_for(:restaurant, name: nil) }
        restaurant.reload
        expect(restaurant.name).to_not be_nil
      end

      it 're-renders the edit method' do
        patch :update, params: { id: restaurant.id, restaurant: attributes_for(:restaurant, name: nil) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the restaurant' do
      restaurant
      expect {
        delete :destroy, params: { id: restaurant.id }
      }.to change(Restaurant, :count).by(-1)
    end

    it 'redirects to the owner dashboard' do
      delete :destroy, params: { id: restaurant.id }
      expect(response).to redirect_to(owner_dashboard_index_path)
    end
  end

  describe 'before actions' do
    describe 'authenticate_user!' do
      it 'redirects to sign in page if user is not authenticated' do
        sign_out owner
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'ensure_owner' do
      it 'redirects to root path if user is not an owner' do
        visitor = create(:user)
        sign_in visitor
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'set_restaurant_instance' do
      it 'sets the correct restaurant for the current user' do
        get :edit, params: { id: restaurant.id }
        expect(assigns(:restaurant)).to eq(restaurant)
      end

      it 'raises an error if the restaurant does not belong to the current user' do
        other_owner = create(:user, :owner)
        other_restaurant = create(:restaurant, owner: other_owner)
        expect {
          get :edit, params: { id: other_restaurant.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
