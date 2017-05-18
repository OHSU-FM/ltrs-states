require 'rails_helper'

RSpec.describe "LeaveRequests index", type: :request do
  describe "GET /leave_requests" do
    it "does the right things" do
      get leave_requests_path
      expect(response).to have_http_status(200)
      expect(response).to render_template :index
    end
  end
end
