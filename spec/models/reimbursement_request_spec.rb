require 'rails_helper'

RSpec.describe ReimbursementRequest, type: :model do
  it 'has a factory' do
    expect(build :reimbursement_request).to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :reimbursement_request).approval_state).to be_an ApprovalState
  end

  it 'requires a form_email' do
    expect(build :reimbursement_request, form_email: nil).not_to be_valid
  end

  it 'requires a form_user' do
    expect(build :reimbursement_request, form_user: nil).not_to be_valid
  end

  it 'requires a user' do
    expect(build :reimbursement_request, user: nil).not_to be_valid
  end
end
