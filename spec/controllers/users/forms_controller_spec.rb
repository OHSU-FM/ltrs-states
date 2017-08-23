require 'rails_helper'

RSpec.describe Users::FormsController, type: :controller do
  describe 'GET #index' do
    login_user
    it 'sets the user to @user' do
      user = create :user
      get :index, params: { user_id: user.to_param }
      expect(assigns(:user)).to eq user
    end

    it 'assigns approvables for a user to @approvables' do
      leave_request = create :leave_request
      get :index, params: { user_id: leave_request.user.to_param }
      expect(assigns(:approvables)).to include leave_request
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
