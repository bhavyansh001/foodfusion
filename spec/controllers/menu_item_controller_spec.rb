require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  let(:owner) { create(:user, :owner) }
  let(:restaurant) { create(:restaurant, owner:) }
  let(:menu_item) { create(:menu_item, menu: restaurant.menu) }
  let(:valid_attributes) { attributes_for(:menu_item) }
  let(:invalid_attributes) { attributes_for(:menu_item, name: nil) }

  before do
    sign_in owner
    restaurant.menu = create(:menu)
  end

  describe 'GET #new' do
    it 'assigns a new menu_item as @menu_item' do
      get :new, params: { restaurant_id: restaurant.id }
      expect(assigns(:menu_item)).to be_a_new(MenuItem)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MenuItem' do
        expect {
          post :create, params: { restaurant_id: restaurant.id, menu_item: valid_attributes }
        }.to change(MenuItem, :count).by(1)
      end

      it 'redirects to the restaurant dashboard' do
        post :create, params: { restaurant_id: restaurant.id, menu_item: valid_attributes }
        expect(response).to redirect_to(dashboard_path(restaurant))
      end

      it 'responds to turbo_stream format' do
        post :create, params: { restaurant_id: restaurant.id, menu_item: valid_attributes }, format: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context 'with invalid params' do
      it 'does not create a new MenuItem' do
        expect {
          post :create, params: { restaurant_id: restaurant.id, menu_item: invalid_attributes }
        }.to change(MenuItem, :count).by(0)
      end

      it 're-renders the new template' do
        post :create, params: { restaurant_id: restaurant.id, menu_item: invalid_attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested menu_item as @menu_item' do
      get :edit, params: { restaurant_id: restaurant.id, id: menu_item.id }
      expect(assigns(:menu_item)).to eq(menu_item)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Item' } }

      it 'updates the requested menu_item' do
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: new_attributes }
        menu_item.reload
        expect(menu_item.name).to eq('Updated Item')
      end

      it 'redirects to the restaurant dashboard' do
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: new_attributes }
        expect(response).to redirect_to(dashboard_path(restaurant))
      end

      it 'responds to turbo_stream format' do
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: new_attributes }, format: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context 'with invalid params' do
      it 'does not update the menu_item' do
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: invalid_attributes }
        expect(menu_item.reload.name).not_to be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested menu_item' do
      menu_item
      expect {
        delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      }.to change(MenuItem, :count).by(-1)
    end

    it 'redirects to the restaurant dashboard' do
      delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      expect(response).to redirect_to(dashboard_path(restaurant))
    end

    it 'responds to turbo_stream format' do
      delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe 'before actions' do
    it 'requires authentication' do
      sign_out owner
      get :new, params: { restaurant_id: restaurant.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'requires owner role' do
      non_owner = create(:user)
      sign_in non_owner
      get :new, params: { restaurant_id: restaurant.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied.')
    end

    it 'sets the correct restaurant' do
      get :new, params: { restaurant_id: restaurant.id }
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it 'sets the correct menu_item for edit, update, and destroy actions' do
      get :edit, params: { restaurant_id: restaurant.id, id: menu_item.id }
      expect(assigns(:menu_item)).to eq(menu_item)
    end
  end
end
