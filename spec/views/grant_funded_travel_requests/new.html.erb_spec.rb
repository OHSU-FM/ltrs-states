require 'rails_helper'

RSpec.describe 'grant_funded_travel_requests/new', type: :view do
  before(:each) do
    assign(:gf_travel_request, build(:gf_travel_request))
    assign(:travel_profile, {})
  end

  context 'as user' do
    login_user

    it 'doesnt show the delegate dropdown' do
      render

      expect(rendered).to have_content "Submitting Travel Request as: #{controller.current_user.full_name}"
    end
  end

  context 'as user with delegators' do
    login_user
    let(:d) { controller.current_user }
    let(:u) { create :user }
    let!(:delegation) { create :user_delegation, user: u, delegate_user: d }

    it 'shows the delegate dropdown' do
      render
      expect(rendered).to have_content 'Submit request for:'
      expect(rendered).to have_content d.full_name
      expect(rendered).to have_content u.full_name
    end
  end
end
