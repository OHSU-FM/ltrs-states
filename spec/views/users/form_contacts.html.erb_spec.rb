require 'rails_helper'

RSpec.describe 'users/_form_contacts', type: :view do
  context 'basic user' do

    before(:each) do
      @user = create :user_with_approvers
      sign_in @user
      render partial: 'users/form_contacts', locals: { user: @user }
    end

    it 'should render something' do
      expect(rendered).to have_content
    end

    it 'should render a row for each user approver (two)' do
      expect(rendered).to have_css("span.glyphicon-minus-sign", count: 2)
    end
  end
end
