require 'rails_helper'

RSpec.describe "approval_states/new", type: :view do
  before(:each) do
    assign(:approval_state, ApprovalState.new())
  end

  it "renders new approval_state form" do
    render

    assert_select "form[action=?][method=?]", approval_states_path, "post" do
    end
  end
end
