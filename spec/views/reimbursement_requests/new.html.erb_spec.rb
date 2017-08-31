require 'rails_helper'

RSpec.describe "reimbursement_requests/new", type: :view do
  before(:each) do
    @user = create :user_with_approvers
    controller.stubs(:current_user).returns(@user)
    assign(:reimbursement_request, build(:reimbursement_request, user: @user))
  end

  it "renders new reimbursement_request form" do
    render

    expect(rendered).to have_content 'New'
    assert_select "form[action=?][method=?]", reimbursement_requests_path, "post" do
    end
  end
end
