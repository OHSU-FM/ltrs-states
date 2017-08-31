require 'rails_helper'

RSpec.describe Users::ApprovalsHelper, type: :helper do
  describe 'hf_approval_state_permitted_options' do
    it 'returns status depending on approval_state' do
      as = create(:leave_request, :submitted).approval_state
      expect(helper.hf_approval_state_permitted_options(as))
        .to eq [["Unopened", "send_to_unopened"], ["Submitted", "submitted"]]
    end
  end
end
