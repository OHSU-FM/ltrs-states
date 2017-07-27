require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/index", type: :view do
  before(:each) do
    assign(:grant_funded_travel_requests, [
      GrantFundedTravelRequest.create!(),
      GrantFundedTravelRequest.create!()
    ])
  end

  it "renders a list of grant_funded_travel_requests" do
    render
  end
end
