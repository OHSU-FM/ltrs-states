require 'rails_helper'

RSpec.describe "travel_requests/new", type: :view do
  before(:each) do
    assign(:travel_request, build(:travel_request))
  end

  context 'as user' do
    login_user

    it 'doesnt show the delegate dropdown' do
      render

      expect(rendered).to have_content "Person requesting travel"
    end
  end

  # TODO delegation for travel_requests
  # context 'as user with delegators' do
  #   login_user
  #   let(:d) { controller.current_user }
  #   let(:u) { create :user }
  #   let!(:delegation) { create :user_delegation, user: u, delegate_user: d }
  #
  #   it 'shows the delegate dropdown' do
  #     render
  #     expect(rendered).to have_content 'Submit request for:'
  #     expect(rendered).to have_content d.full_name
  #     expect(rendered).to have_content u.full_name
  #   end
  # end
end
