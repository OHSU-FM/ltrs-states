require 'rails_helper'

RSpec.describe "travel_requests/edit", type: :view do
  before(:each) do
    @travel_request = assign(:travel_request, TravelRequest.create!())
  end

  it "renders the edit travel_request form" do
    render

    assert_select "form[action=?][method=?]", travel_request_path(@travel_request), "post" do
    end
  end
end
