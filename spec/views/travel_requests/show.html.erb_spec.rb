require 'rails_helper'

RSpec.describe "travel_requests/show", type: :view do
  before(:each) do
    @travel_request = assign(:travel_request, TravelRequest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
