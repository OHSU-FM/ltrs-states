require 'rails_helper'

RSpec.describe 'users/shared/_forms_approval_status', type: :view do
  context 'basic user' do

    before(:each) do
      @user = create :user_with_approvers
      @record = create(:leave_request, user: @user)
      sign_in @user
      render partial: 'users/shared/forms_approval_status',
        locals: { record: @record, user: @user }
    end

    it 'should render the current users full_name' do
      expect(rendered).to have_content(@user.full_name)
    end

    it 'should render the current users email' do
      expect(rendered).to have_content(assigns[:current_user].email)
    end

    it 'should render the full_names of current users reviewers' do
      @user.reviewers.map(&:approver).each do |appr|
        expect(rendered).to have_content(appr.full_name)
      end
    end

    it 'should render the verdict for the request' do
      expect(rendered).to have_content(@record.approval_state.verdict)
    end
  end
end
