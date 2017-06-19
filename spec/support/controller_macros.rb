module ControllerMacros
  def login_user u = nil
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = u || FactoryGirl.create(:user)
      sign_in user
    end
  end
end
