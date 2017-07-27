require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/edit", type: :view do
  before(:each) do
    @grant_funded_travel_request = assign(:grant_funded_travel_request, GrantFundedTravelRequest.create!())
  end

  it "renders the edit grant_funded_travel_request form" do
    render

    assert_select "form[action=?][method=?]", grant_funded_travel_request_path(@grant_funded_travel_request), "post" do
    end
  end
end
