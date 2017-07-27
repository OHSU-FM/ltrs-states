require 'rails_helper'

RSpec.describe "GrantFundedTravelRequests", type: :request do
  describe "GET /grant_funded_travel_requests" do
    it "works! (now write some real specs)" do
      get grant_funded_travel_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
