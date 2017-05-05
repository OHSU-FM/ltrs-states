require 'rails_helper'

RSpec.describe "leave_requests/index", type: :view do
  before(:each) do
    assign(:leave_requests, [
      LeaveRequest.create!(),
      LeaveRequest.create!()
    ])
  end

  it "renders a list of leave_requests" do
    render
  end
end
