require 'rails_helper'

RSpec.describe 'home/index', type: :view do
  context 'basic user' do
    login_user

    before(:each) do
      render
    end

    it 'should render a button to account' do
      expect(rendered).to have_selector :link_or_button, 'Account'
    end

    it 'should render a button to the users forms' do
      expect(rendered).to have_selector :link_or_button, 'My Forms'
    end

    it 'should render a button to create a new form' do
      expect(rendered).to have_selector :link_or_button, 'New Request'
    end
  end
end
