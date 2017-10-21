require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #show' do
    context 'with logged in user' do
      login_user
      let(:user) { controller.current_user }

      it 'assigns the user to @user' do
        get :show, params: { id: user.to_param }
        expect(assigns(:user)).to eq user
      end

      it 'denies access if unauthorized user tries to access different user' do
        user2 = create :user
        get :show, params: { id: user2.to_param }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).not_to be_empty
      end
    end

    context 'without logged in user' do
      it 'redirects to login' do
        user = create :user
        get :show, params: { id: user.to_param }
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    context 'with logged in user' do
      login_user
      let(:user) { controller.current_user }

      it 'updates the user' do
        updated_params = user.attributes.update(cell_number: '111111111')
        patch :update, params: { id: user.id, user: updated_params }
        user.reload
        expect(user.cell_number).to eq '111111111'
      end
    end

    context 'without logged in user' do
      it 'redirects to login' do
        user = create :user
        put :update, params: { id: user.to_param }
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).not_to be_empty
      end
    end
  end

  describe 'GET #travel_profile' do
    context 'with logged_in delegate' do
      login_delegate
      let(:user) { controller.current_user.delegators.first }

      it 'returns a hash of the delegators travel profile as json' do
        h = { 'tsa_pre': '42069' }
        user.update!(h)
        get :travel_profile, params: { user_id: user.to_param }, format: :json
        expect(JSON.parse(response.body)["travel_profile"]["tsa_pre"]).to eq '42069'
      end
    end
  end
end
