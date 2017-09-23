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

  it 'requires a user' do
    expect(build :gf_travel_request, user: nil).not_to be_valid
  end

  it 'requires a desc of the destination' do
    expect(build :gf_travel_request, dest_desc: nil).not_to be_valid
  end

  it 'requires a business_purpose_desc' do
    expect(build :gf_travel_request, business_purpose_desc: nil).not_to be_valid
    expect(build :gf_travel_request, business_purpose_desc: '').not_to be_valid
  end

  it 'requires an expense_card_use' do
    expect(build :gf_travel_request, expense_card_use: nil).not_to be_valid
  end

  it 'requires an answer to air_use' do
    expect(build :gf_travel_request, air_use: nil).not_to be_valid
  end

  it 'requires an answer to car_rental' do
    expect(build :gf_travel_request, car_rental: nil).not_to be_valid
  end

  it 'requires an answer to registration_reimb' do
    expect(build :gf_travel_request, registration_reimb: nil).not_to be_valid
  end

  it 'requires an answer to lodging_reimb' do
    expect(build :gf_travel_request, lodging_reimb: nil).not_to be_valid
  end

  it 'requires an answer to ground_transport' do
    expect(build :gf_travel_request, ground_transport: nil).not_to be_valid
  end

  it 'requires a business_purpose_url if business_purpose_desc is conference' do
    [nil, '', 'not a url'].each do |invalid_url|
      expect(build :gf_travel_request, business_purpose_desc: 'conference',
             business_purpose_url: invalid_url).not_to be_valid
    end
  end

  it 'requires a business_purpose_other if business_purpose_desc is other' do
    expect(build :gf_travel_request, business_purpose_desc: 'other',
           business_purpose_other: '').not_to be_valid
  end

  it 'requires that dates make sense' do
    expect(build :gf_travel_request, depart_date: 2.day.from_now,
           return_date: 1.day.from_now).not_to be_valid
  end

  it 'requires that an award is selected if expense_card_use is true' do
    expect(build :gf_travel_request, expense_card_use: true,
           expense_card_type: nil).not_to be_valid
  end

  it 'requires air_assistance if air_use is true' do
    expect(build :gf_travel_request, air_use: true, air_assistance: nil)
      .not_to be_valid
  end

  it 'requires car_assistance if car_rental is true' do
    expect(build :gf_travel_request, car_rental: true, car_assistance: nil)
      .not_to be_valid
  end

  it 'requires lodging_assistance if lodging_reimb is true' do
    expect(build :gf_travel_request, lodging_reimb: true,
           lodging_assistance: nil).not_to be_valid
  end

  it 'requires rental details if car_assistance is true' do
    expect(build :gf_travel_request, car_assistance: true, cell_number: nil)
      .not_to be_valid
    expect(build :gf_travel_request, car_assistance: true, cell_number: 'NaN')
      .not_to be_valid
    expect(build :gf_travel_request, car_assistance: true,
           drivers_licence_num: nil).not_to be_valid
    expect(build :gf_travel_request, car_assistance: true,
           rental_needs_desc: nil).not_to be_valid
  end

  it 'requires registration_assistance if registration_reimb is true' do
    expect(build :gf_travel_request, registration_reimb: true,
           registration_assistance: nil).not_to be_valid
  end

  it 'requires registration_url if registration_assistance is true' do
    [nil, '', 'not a url'].each do |invalid_url|
      expect(build :gf_travel_request, registration_assistance: true,
             registration_url: invalid_url).not_to be_valid
    end
  end

  it 'requires lodging_url if lodging_assistance is true' do
    [nil, '', 'not a url'].each do |invalid_url|
      expect(build :gf_travel_request, lodging_assistance: true,
             lodging_url: invalid_url).not_to be_valid
    end
  end

  it 'requires ground_transport_assistance if ground_transport is true' do
    expect(build :gf_travel_request, ground_transport: true,
           ground_transport_assistance: nil).not_to be_valid
  end

  it 'requires ground_transport_desc if ground_transport_assistance is true' do
    expect(build :gf_travel_request, ground_transport_assistance: true,
           ground_transport_desc: nil).not_to be_valid
  end

  describe 'methods' do
    it '#to_s returns a string representation of the object' do
      gftr = create :gf_travel_request
      expect(gftr.to_s).to eq "GrantFundedTravelRequest #{gftr.id}"
    end

    it '#delegate_submitted? returns false if from_email == user.email' do
      gftr = create :gf_travel_request
      expect(gftr.delegate_submitted?).to be_falsey
    end

    it '#delegate_submitted? returns true if form_email != user.email' do
      d_gftr = create :delegated_gftr
      expect(d_gftr.delegate_submitted?).to be_truthy
    end
  end
end
