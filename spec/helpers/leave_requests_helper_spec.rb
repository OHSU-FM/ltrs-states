require 'rails_helper'

RSpec.describe LeaveRequestsHelper, type: :helper do
  before(:each) do
    @lr = create :leave_request
  end

  context 'given a possible approval state,'  do
    describe "#button_to_state_path" do
      it "should return path of appropriate controller action" do
        state = @lr.approval_state.aasm.events(permissible: true).first.name
        expect(helper.button_to_state_path(state)).to eq "submit_leave_request_path"
      end
    end
  end
end
