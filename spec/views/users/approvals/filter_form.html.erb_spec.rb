require 'rails_helper'

RSpec.describe 'users/approvals/_filter_form', type: :view do
  context 'as reviewer' do
    login_reviewer
    before(:each) do
      @lr = create :leave_request, user: controller.current_user.reviewable_users.last
      apr = WillPaginate::Collection.create(1, 10, 1) do |p|
        p.replace [@lr]
      end
      assign(:user, controller.current_user)
      assign(:approvals, apr)
    end

    it 'sets the title when there is no filter' do
      render
      expect(rendered).to have_content 'Selecting from all approvals'
    end

    it 'sets the title when there filter is past' do
      assign(:filter_name, 'past')
      render
      expect(rendered).to have_content 'These are the requests that you have accepted/rejected.'
    end

    it 'sets the title when there filter is active' do
      assign(:filter_name, 'active')
      render
      expect(rendered).to have_content 'These are the requests that you have approved that are still awaiting final approval.'
    end

    it 'sets the title when there filter is upcoming' do
      assign(:filter_name, 'upcoming')
      render
      expect(rendered).to have_content 'These are the requests that have been submitted but do not yet require your approval.'
    end

    it 'sets the title when there filter is pending' do
      assign(:filter_name, 'pending')
      render
      expect(rendered).to have_content 'These are the requests that are waiting for your approval.'
    end

    it 'sets the title when there filter is unsubmitted' do
      assign(:filter_name, 'unsubmitted')
      render
      expect(rendered).to have_content 'These are the requests that have not been submitted.'
    end
  end
end
