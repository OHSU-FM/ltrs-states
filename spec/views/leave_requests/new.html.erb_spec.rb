require 'rails_helper'

RSpec.describe 'leave_requests/new', type: :view do
  login_user

  before(:each) do
    assign(:leave_request, build(:leave_request))
    render
  end

  it 'renders new leave_request form' do
    expect(rendered).to have_content 'New'
    expect(rendered).to have_content 'Leave Request'
    expect(rendered).to have_selector :link_or_button, 'Save'
  end
end
