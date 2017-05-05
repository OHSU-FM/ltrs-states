require 'rails_helper'

RSpec.describe "approval_states/show", type: :view do
  before(:each) do
    @approval_state = assign(:approval_state, ApprovalState.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
