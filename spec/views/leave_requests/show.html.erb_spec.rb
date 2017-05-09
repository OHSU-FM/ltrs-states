require 'rails_helper'

RSpec.describe "leave_requests/show", type: :view do
  before(:each) do
    @leave_request = assign(:leave_request, (create :leave_request))
  end

  it "renders buttons for permissible state transistions" do
    render

    expect(rendered).to have_selector(:link_or_button, "Submit")
  end
end
