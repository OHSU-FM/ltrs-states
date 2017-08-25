require 'rails_helper'

RSpec.describe 'users/forms/index', type: :view do
  login_user
  before(:each) do
    @lr = create :leave_request, user: controller.current_user
    apr = WillPaginate::Collection.create(1, 10, 1) do |p|
      p.replace [@lr]
    end
    assign(:user, controller.current_user)
    assign(:approvables, apr)
    render
  end

  it 'renders a row for each request' do
    expect(rendered).to have_content @lr.user.full_name
    expect(rendered).to have_selector(:css, 'img.icon-request')
  end
end
