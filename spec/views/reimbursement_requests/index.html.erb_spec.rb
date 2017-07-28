require 'rails_helper'

RSpec.describe "reimbursement_requests/index", type: :view do
  before(:each) do
    assign(:reimbursement_requests, [
      ReimbursementRequest.create!(),
      ReimbursementRequest.create!()
    ])
  end

  it "renders a list of reimbursement_requests" do
    render
  end
end
