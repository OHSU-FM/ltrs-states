require 'rails_helper'

RSpec.describe Users::FormsHelper, type: :helper do
  describe 'hf_row_status' do
    it 'returns status depending on approval_state' do
      as = create :leave_request, :submitted
      expect(helper.hf_row_status(as.approval_state)).to eq('info')
    end
  end
end
