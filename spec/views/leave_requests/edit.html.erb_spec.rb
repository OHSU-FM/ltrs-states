require 'rails_helper'

RSpec.describe "leave_requests/edit", type: :view do
  before(:each) do
    @leave_request = assign(:leave_request, LeaveRequest.create!())
  end

  it "renders the edit leave_request form" do
    render

    assert_select "form[action=?][method=?]", leave_request_path(@leave_request), "post" do
    end
  end
end
