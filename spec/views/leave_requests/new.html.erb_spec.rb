require 'rails_helper'

RSpec.describe "leave_requests/new", type: :view do
  before(:each) do
    assign(:leave_request, LeaveRequest.new())
  end

  it "renders new leave_request form" do
    render

    assert_select "form[action=?][method=?]", leave_requests_path, "post" do
    end
  end
end
