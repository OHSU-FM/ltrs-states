require 'rails_helper'

RSpec.describe "travel_requests/new", type: :view do
  before(:each) do
    assign(:travel_request, TravelRequest.new())
  end

  it "renders new travel_request form" do
    render

    assert_select "form[action=?][method=?]", travel_requests_path, "post" do
    end
  end
end
