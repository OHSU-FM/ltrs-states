require 'rails_helper'

RSpec.describe "approval_states/edit", type: :view do
  before(:each) do
    @approval_state = assign(:approval_state, ApprovalState.create!())
  end

  it "renders the edit approval_state form" do
    render

    assert_select "form[action=?][method=?]", approval_state_path(@approval_state), "post" do
    end
  end
end
