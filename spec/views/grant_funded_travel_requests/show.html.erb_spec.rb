require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/show", type: :view do
  before(:each) do
    @user = create :user_with_approvers
    controller.stubs(:current_user).returns(@user)
    @gf_travel_request = assign(:gf_travel_request, create(:gf_travel_request, user: @user))
  end

  it "renders attributes in <p>" do
    render
  end
end
