require 'rails_helper'

RSpec.describe "reimbursement_requests/edit", type: :view do
  before(:each) do
    @rr = assign(:reimbursement_request, create(:reimbursement_request))
  end

  it "renders the edit reimbursement_request form" do
    render

    assert_select "form[action=?][method=?]", reimbursement_request_path(@rr), "post" do
    end
  end
end
