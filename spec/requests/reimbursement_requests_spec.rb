require 'rails_helper'

RSpec.describe "ReimbursementRequests", type: :request do
  describe "GET /reimbursement_requests" do
    it "works! (now write some real specs)" do
      get reimbursement_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
