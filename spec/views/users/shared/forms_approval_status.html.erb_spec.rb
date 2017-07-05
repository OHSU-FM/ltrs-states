require 'rails_helper'

RSpec.describe 'users/shared/_forms_approval_status', type: :view do
  context 'basic user' do

    before(:each) do
      @user = create :user
      @record = create(:leave_request, user: @user)
      sign_in @user
      render partial: 'users/shared/forms_approval_status',
        locals: { record: @record }
    end

    it 'should render the current users full_name' do
      expect(rendered).to have_content(@user.full_name)
    end

    it 'should render the current users email' do
      expect(rendered).to have_content(assigns[:current_user].email)
    end
  end
end
