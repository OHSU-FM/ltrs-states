require 'rails_helper'

RSpec.describe "LeaveRequests", type: :request do
  describe "GET /leave_requests" do
    it "works! (now write some real specs)" do
      get leave_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
