require 'rails_helper'

RSpec.describe "approval_states/index", type: :view do
  before(:each) do
    assign(:approval_states, [
      ApprovalState.create!(),
      ApprovalState.create!()
    ])
  end

  it "renders a list of approval_states" do
    render
  end
end
