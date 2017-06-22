require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #show' do
    login_user

    it 'assigns the requested leave_request as @leave_request' do
      user = create :user
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq user
    end

    it 'denies access if unauthorized user tries to access different user' do
      create :user
      user = create :user
      get :show, params: { id: "#{user.to_param.to_i - 1}" }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).not_to be_empty
    end
  end
end
