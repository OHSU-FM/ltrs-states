require 'rails_helper'

RSpec.describe 'leave_requests/show', type: :view do
  before(:each) do
    @leave_request = assign(:leave_request, (create :leave_request))
  end

  it 'shows the current state of the request' do
    render
    within('h1') { expect(page).to have_content('unsubmitted') }
  end

  it 'renders buttons for permissible state transistions' do
    render
    expect(rendered).to have_selector(:link_or_button, "Submit")
  end

  it 'renders a link back to index' do
    render
    expect(rendered).to have_link("Back", href: leave_requests_path)
  end

  it 'renders a delete link' do
    render
    expect(rendered).to have_link("Destroy", href: leave_request_path(@leave_request))
  end
end
