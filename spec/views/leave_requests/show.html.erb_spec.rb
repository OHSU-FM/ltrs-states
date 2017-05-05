require 'rails_helper'

RSpec.describe "leave_requests/show", type: :view do
  before(:each) do
    @leave_request = assign(:leave_request, LeaveRequest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
