require 'rails_helper'

RSpec.describe "travel_requests/edit", type: :view do
  before(:each) do
    @user = create :user_with_approvers
    allow(controller).to receive(:current_user) { @user }
    @travel_request = assign(:travel_request, create(:travel_request, user: @user))
  end

  it "renders the edit travel_request form" do
    render

    expect(rendered).to have_content "Edit"
    assert_select "form[action=?][method=?]", travel_request_path(@travel_request), "post" do
    end
  end
end
