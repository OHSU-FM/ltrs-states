require 'rails_helper'

RSpec.describe "reimbursement_requests/edit", type: :view do
  before(:each) do
    @reimbursement_request = assign(:reimbursement_request, ReimbursementRequest.create!())
  end

  it "renders the edit reimbursement_request form" do
    render

    assert_select "form[action=?][method=?]", reimbursement_request_path(@reimbursement_request), "post" do
    end
  end
end
