require 'rails_helper'

RSpec.describe "travel_requests/index", type: :view do
  before(:each) do
    assign(:travel_requests, [
      TravelRequest.create!(),
      TravelRequest.create!()
    ])
  end

  it "renders a list of travel_requests" do
    render
  end
end
