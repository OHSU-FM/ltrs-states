require 'rails_helper'

RSpec.describe GrantFundedTravelRequest, type: :model do
  it 'has a factory' do
    expect(build :gf_travel_request).to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :gf_travel_request).approval_state).to be_an ApprovalState
  end

  it 'requires a depart_date' do
    expect(build :gf_travel_request, depart_date: nil).not_to be_valid
  end

  it 'requires a return_date' do
    expect(build :gf_travel_request, return_date: nil).not_to be_valid
  end

  it 'requires a form_email' do
    expect(build :gf_travel_request, form_email: nil).not_to be_valid
  end

  it 'requires a form_user' do
    expect(build :gf_travel_request, form_user: nil).not_to be_valid
  end

  it 'requires a user' do
    expect(build :gf_travel_request, user: nil).not_to be_valid
  end

  it 'requires a business_purpose_url if business_purpose_desc is conference' do
    expect(build :gf_travel_request, business_purpose_desc: 'conference',
           business_purpose_url: '').not_to be_valid
  end

  it 'requires a business_purpose_other if business_purpose_desc is other' do
    expect(build :gf_travel_request, business_purpose_desc: 'other',
           business_purpose_other: '').not_to be_valid
  end

  it 'requires that dates make sense' do
    expect(build :gf_travel_request, depart_date: 2.day.from_now,
           return_date: 1.day.from_now).not_to be_valid
  end
end
