require 'rails_helper'

RSpec.describe Users::FormsController, type: :controller do
  describe 'GET #index' do
    context 'as normal user' do
      login_user
      let(:user) { controller.current_user }

      it 'sets the user to @user' do
        get :index, params: { user_id: user.to_param }
        expect(assigns(:user)).to eq user
      end

      it 'assigns approvables for a user to @approvables' do
        leave_request = create :leave_request, user: user
        get :index, params: { user_id: user.to_param }
        expect(assigns(:approvables)).to include leave_request
      end

      it 'paginates approvables' do
        leave_requests = create_list(:leave_request, 11, user: user)
        get :index, params: { user_id: user.to_param }
        expect(assigns(:approvables).count).to eq 10
      end

      it 'redirects if user requests index for another user' do
        other_user = create :user
        get :index, params: { user_id: other_user.to_param }
        expect(response).to redirect_to root_path
      end
    end

    context 'as admin' do
      login_admin

      let(:other_user) { create :user }

      it 'can access index for other users' do
        get :index, params: { user_id: other_user.to_param }
        expect(response).to be_success
      end

      it 'sets the user to @user' do
        get :index, params: { user_id: other_user.to_param }
        expect(assigns(:user)).to eq other_user
      end

      it 'assigns approvables for a user to @approvables' do
        leave_request = create :leave_request, user: other_user
        get :index, params: { user_id: other_user.to_param }
        expect(assigns(:approvables)).to include leave_request
      end
    end
  end

  describe 'GET #delegate_forms' do
    login_user

    it 'sets the user to @user' do
      user = create :user
      get :delegate_forms, params: { user_id: user.to_param }
      expect(assigns(:user)).to eq user
    end

    context 'when user has delegators' do
      let(:user) { create :complete_user_with_delegate }
      let(:d) { user.delegates.first }
      let!(:lr) { create :leave_request, :submitted, user: user }
      let(:other_lr) { create :leave_request, :submitted }

      it 'assigns approvables for a user to @approvables' do
        get :delegate_forms, params: { user_id: d.to_param }
        expect(assigns(:approvables)).to include lr
        expect(assigns(:approvables)).not_to include other_lr
      end
    end

    context 'when user doesnt have delegators' do
      let(:user) { create :user }

      it 'assigns @approvables to []' do
        get :delegate_forms, params: { user_id: user.to_param }
        expect(assigns(:approvables)).to eq []
      end
    end
  end
end
