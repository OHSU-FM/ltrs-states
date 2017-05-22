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

RSpec.describe "LeaveRequests show", type: :request do
  let(:leave_request) { create :leave_request }
  describe "GET /leave_request" do
    it "does the right things" do
      get leave_request_path leave_request
      expect(response).to have_http_status(200)
      expect(response).to render_template :show
    end
  end
end
