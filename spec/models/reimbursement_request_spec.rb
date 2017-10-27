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

  it 'requires a depart_date' do
    expect(build :reimbursement_request, depart_date: nil).not_to be_valid
  end

  it 'requires a return_date' do
    expect(build :reimbursement_request, return_date: nil).not_to be_valid
  end

  it 'generates a MealReimbursementRequest for each day of travel' do
    rr = create :reimbursement_request, depart_date: 1.day.ago, return_date: 1.day.from_now
    expect(rr.meal_reimbursement_requests.first).to be_a MealReimbursementRequest
    expect(rr.meal_reimbursement_requests.count).to eq 3
  end

  describe 'user_files' do
    it '#itinerary_ufs returns user_files of document_type Itinerary' do
      rr = create :reimbursement_request
      uf = create :full_user_file, fileable: rr, document_type: 'Itinerary'
      uf2 = create :full_user_file, fileable: rr, document_type: 'SomethingElse'
      expect(rr.itinerary_ufs).to include uf
      expect(rr.itinerary_ufs).not_to include uf2
    end

    it '#agenda_ufs returns user_files of document_type Agenda' do
      rr = create :reimbursement_request
      uf = create :full_user_file, fileable: rr, document_type: 'Agenda'
      uf2 = create :full_user_file, fileable: rr, document_type: 'SomethingElse'
      expect(rr.agenda_ufs).to include uf
      expect(rr.agenda_ufs).not_to include uf2
    end

    it '#miles_map_ufs returns user_files of document_type MilesMap' do
      rr = create :reimbursement_request
      uf = create :full_user_file, fileable: rr, document_type: 'MilesMap'
      uf2 = create :full_user_file, fileable: rr, document_type: 'SomethingElse'
      expect(rr.miles_map_ufs).to include uf
      expect(rr.miles_map_ufs).not_to include uf2
    end

    it '#exception_apps returns user_files of document_type ExceptionApp' do
      rr = create :reimbursement_request
      uf = create :full_user_file, fileable: rr, document_type: 'ExceptionApp'
      uf2 = create :full_user_file, fileable: rr, document_type: 'SomethingElse'
      expect(rr.exception_apps).to include uf
      expect(rr.exception_apps).not_to include uf2
    end
  end

  describe 'methods' do
    it '#to_s returns a string representation of the object' do
      rr = create :reimbursement_request
      expect(rr.to_s).to eq "ReimbursementRequest #{rr.id}"
    end

    it '#has_na_meal_reimb? returns true if any meal reimbursement_request is na' do
      rr = create :reimbursement_request
      rr.meal_reimbursement_requests.first.update!(lunch: false)
      expect(rr.has_na_meal_reimb?).to be_truthy
    end
  end
end
