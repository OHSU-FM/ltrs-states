require 'rails_helper'

RSpec.describe 'users/approvals/index', type: :view do
  context 'as reviewer' do
    login_reviewer
    before(:each) do
      @lr = create :leave_request, user: controller.current_user.reviewable_users.last
      apr = WillPaginate::Collection.create(1, 10, 1) do |p|
        p.replace [@lr]
      end
      assign(:user, controller.current_user)
      assign(:approvals, apr)
      render
    end

    it 'sets the title' do
      expect(rendered).to have_content 'All Approvals'
    end
  end
end
