require 'rails_helper'

RSpec.describe "reimbursement_requests/show", type: :view do
  before(:each) do
    @user = create :user_with_approvers
    allow(controller).to receive(:current_user) { @user }
    @reimbursement_request = assign(:reimbursement_request, create(:reimbursement_request, user: @user))
  end

  it "renders attributes in <p>" do
    render
  end
end
