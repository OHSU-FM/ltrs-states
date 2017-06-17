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

    # TODO should set delegate forms to @approvables
    it 'assigns approvables for a user to @approvables' do
      pending('implement delegate behavior')
      fail
    end
  end
end
