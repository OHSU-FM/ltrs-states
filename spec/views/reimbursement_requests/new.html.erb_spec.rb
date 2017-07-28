require 'rails_helper'

RSpec.describe "reimbursement_requests/new", type: :view do
  before(:each) do
    assign(:reimbursement_request, ReimbursementRequest.new())
  end

  it "renders new reimbursement_request form" do
    render

    assert_select "form[action=?][method=?]", reimbursement_requests_path, "post" do
    end
  end
end
