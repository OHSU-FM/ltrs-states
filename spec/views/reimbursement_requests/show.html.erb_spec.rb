require 'rails_helper'

RSpec.describe "reimbursement_requests/show", type: :view do
  before(:each) do
    @reimbursement_request = assign(:reimbursement_request, ReimbursementRequest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
