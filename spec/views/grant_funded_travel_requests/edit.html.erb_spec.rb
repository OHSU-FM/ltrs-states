require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/edit", type: :view do
  before(:each) do
    @user = create :user_with_approvers
    controller.stubs(:current_user).returns(@user)
    @gf_travel_request = assign(:gf_travel_request, create(:gf_travel_request, user: @user))
    assign(:travel_profile, {})
  end

  it "renders the edit grant_funded_travel_request form" do
    render

    expect(rendered).to have_content "Edit"
    assert_select "form[action=?][method=?]", grant_funded_travel_request_path(@gf_travel_request), "post" do
    end
  end
end
