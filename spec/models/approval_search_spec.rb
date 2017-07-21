require 'rails_helper'

RSpec.describe ApprovalSearch, type: :model do
  fdescribe 'search by params' do
    let(:u) { create :user_with_approvers }
    let(:r) { u.reviewers.first.approver }
    let!(:lr) { create :leave_request, :accepted, user: u }
    let!(:tr) { create :travel_request, :submitted, user: u }

    it 'should order by created_at ASC by default' do
      expect(ApprovalSearch.by_params(r, {'filter': 'none'})).to eq [lr, tr]
    end

    it 'should sort DESC if params[:sort_order] == desc' do
      expect(ApprovalSearch.by_params(r, {'sort_order': 'desc', 'filter': 'none'}))
        .to eq [tr, lr]
    end

    it 'should order by updated_at if params[:sort_by] == updated_at' do
      # touch lr so that lr.updated_at > tr.updated_at
      lr.update!(desc: "I've been updated!")
      expect(ApprovalSearch.by_params(r, {'sort_by': 'updated_at', 'filter': 'none'}))
        .to eq [tr, lr]
    end

    it 'should display return only leave_requests if q == leave' do
      expect(ApprovalSearch.by_params(r, {'q': 'leave', 'filter': 'none'})).to eq [lr]
    end

    it 'should display return only travel_requests if q == travel' do
      expect(ApprovalSearch.by_params(r, {'q': 'travel', 'filter': 'none'})).to eq [tr]
    end

    it 'should search fields for query terms' do
      lr.update!(desc: 'going to the moon')
      expect(ApprovalSearch.by_params(r, {'q': 'moon', 'filter': 'none'})).to eq [lr]
      tr.update!(dest_desc: 'also the moon?')
      expect(ApprovalSearch.by_params(r, {'q': 'moon', 'filter': 'none'})).to eq [lr, tr]
    end

    it 'should default to showing only pending requests' do
      expect(ApprovalSearch.by_params(r, {})).to eq [tr]
    end
  end
end
