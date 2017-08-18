require 'rails_helper'

RSpec.describe 'leave_requests/show', type: :view do
  context 'with unsubmitted leave_request' do
    before(:each) do
      @user = create :user_with_approvers
      allow(controller).to receive(:current_user) { @user }
      @leave_request = assign(:leave_request, (create :leave_request, user: @user))
    end

    it 'shows the current state of the request' do
      render
      within('h1') { expect(page).to have_content('Unsubmitted') }
    end

    it 'renders buttons for permissible state transistions' do
      render
      expect(rendered).to have_selector(:link_or_button, "Submit")
    end

    it 'renders a delete link' do
      render
      expect(rendered).to have_link("Delete", href: leave_request_path(@leave_request))
    end
  end
end
