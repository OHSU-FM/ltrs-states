require 'rails_helper'

RSpec.describe 'layouts/_subnav', type: :view do
  context 'basic user' do
    login_user

    before(:each) do
      render
    end

    it 'should render a button to home' do
      expect(rendered).to have_selector :link_or_button, 'Home'
    end

    it 'should render a button to account' do
      expect(rendered).to have_selector :link_or_button, 'Account'
    end

    it 'should render a button to the users forms' do
      expect(rendered).to have_selector :link_or_button, 'My Forms'
    end

    it 'should render a button to sign out' do
      expect(rendered).to have_selector :link_or_button, 'Sign out'
    end

    it 'should not render a button to admin' do
      expect(rendered).not_to have_selector :link_or_button, 'Admin'
    end
  end

  context 'admin user' do
    login_admin

    it 'should render a button to admin' do
      render
      expect(rendered).to have_selector :link_or_button, 'Admin'
    end
  end
end
