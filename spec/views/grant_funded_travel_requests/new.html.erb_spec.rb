require 'rails_helper'

RSpec.describe "grant_funded_travel_requests/new", type: :view do
  before(:each) do
    assign(:grant_funded_travel_request, GrantFundedTravelRequest.new())
  end

  it "renders new grant_funded_travel_request form" do
    render

    assert_select "form[action=?][method=?]", grant_funded_travel_requests_path, "post" do
    end
  end
end
