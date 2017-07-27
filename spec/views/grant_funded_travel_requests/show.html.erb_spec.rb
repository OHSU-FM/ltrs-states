require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/show", type: :view do
  before(:each) do
    @grant_funded_travel_request = assign(:grant_funded_travel_request, GrantFundedTravelRequest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
