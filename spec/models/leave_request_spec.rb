require 'rails_helper'

RSpec.describe LeaveRequest, type: :model do
  it 'has a factory' do
    expect(create :leave_request).to be_valid
  end

  it 'requires a user' do
    expect(build :leave_request, user: nil).not_to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :leave_request).approval_state).to be_an ApprovalState
  end

  it 'destroys dependent approval_state on delete' do
    lr = create :leave_request
    expect{ lr.destroy }.to change{ ApprovalState.count }.by(-1)
  end

  describe 'method' do
    it '#related_record references associated travel_request' do
      expect((create :leave_request, :with_travel_request).related_record)
        .to be_a TravelRequest
    end
  end
end
