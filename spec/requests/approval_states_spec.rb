require 'rails_helper'

RSpec.describe "ApprovalStates", type: :request do
  describe "GET /approval_states" do
    it "works! (now write some real specs)" do
      get approval_states_path
      expect(response).to have_http_status(200)
    end
  end
end
