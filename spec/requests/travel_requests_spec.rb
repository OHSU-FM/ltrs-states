require 'rails_helper'

RSpec.describe "TravelRequests", type: :request do
  describe "GET /travel_requests" do
    it "works! (now write some real specs)" do
      get travel_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
