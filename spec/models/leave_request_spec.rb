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
end
