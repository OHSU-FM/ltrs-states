require 'rails_helper'

RSpec.describe 'users/approvals/index', type: :view do
  context 'as base user' do
    before(:each) do
      @approvals = assign(:approvals, (create :leave_request))
    end
  end
end
