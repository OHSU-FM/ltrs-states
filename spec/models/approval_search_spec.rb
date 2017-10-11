require 'rails_helper'

RSpec.describe ApprovalSearch, type: :model do
  describe 'search by params' do
    let(:u) { create :user_with_approvers }
    let(:r) { u.reviewers.first.approver }
    let!(:lr) { create :leave_request, :accepted, user: u }
    let!(:tr) { create :travel_request, :unopened, user: u }
    let!(:gftr) { create :gf_travel_request, :accepted, :with_rr, user: u }
    let!(:rr) { gftr.reimbursement_request }

    it 'should order by created_at DESC by default' do
      expect(ApprovalSearch.by_params(r, {'filter': 'none'})).to eq [rr, gftr, tr, lr]
    end

    it 'should sort ASC if params[:sort_order] == asc' do
      expect(ApprovalSearch.by_params(r, {'sort_order': 'asc', 'filter': 'none'}))
        .to eq [lr, tr, gftr, rr]
    end

    it 'should order by updated_at if params[:sort_by] == updated_at' do
      # touch lr so that lr.updated_at > tr.updated_at
      lr.update!(desc: "I've been updated!")
      expect(ApprovalSearch.by_params(r, {'sort_by': 'updated_at', 'filter': 'none'}))
        .to eq [lr, rr, gftr, tr]
    end

    it 'should return only leave_requests if q == leave' do
      expect(ApprovalSearch.by_params(r, {'q': 'leave', 'filter': 'none'})).to eq [lr]
    end

    it 'should return travel_requests and grant_funded_travel_requests if q == travel' do
      expect(ApprovalSearch.by_params(r, {'q': 'travel', 'filter': 'none'})).to eq [gftr, tr]
    end

    it 'should return only reimbursement_requests if q == reimbursement' do
      expect(ApprovalSearch.by_params(r, {'q': 'reimbursement', 'filter': 'none'})).to eq [rr]
    end

    it 'should return only leave_requests if q == leave' do
      expect(ApprovalSearch.by_params(r, {'q': 'leave', 'filter': 'none'})).to eq [lr]
    end

    it 'should search fields for query terms' do
      lr.update!(desc: 'going to the moon')
      expect(ApprovalSearch.by_params(r, {'q': 'moon', 'filter': 'none'})).to eq [lr]
      tr.update!(dest_desc: 'also the moon?')
      expect(ApprovalSearch.by_params(r, {'q': 'moon', 'filter': 'none'})).to eq [tr, lr]
    end

    it 'should default to showing only pending requests' do
      expect(ApprovalSearch.by_params(r, {})).to eq [tr]
    end
  end

  describe 'approvals for user with multiple reviewers' do
    let(:u) { create :user_two_reviewers }
    let(:r1) { u.reviewers.first.approver }
    let(:r2) { u.reviewers.last.approver }
    let!(:lr1) { create :leave_request, :unopened, user: u }
    let!(:lr2) { create :leave_request, :back_to_unopened, user: u }

    context 'first reviewer' do
      it "shouldn't include requests that the reviewer has sent down the chain" do
        expect(ApprovalSearch.by_params(r1)).not_to include lr2
      end

      it "should include requests that the reviewer has yet to review" do
        expect(ApprovalSearch.by_params(r1)).to include lr1
      end
    end

    context 'second reviewer' do
      it "shouldn't include requests that prior reviewers haven't reviewed yet" do
        expect(ApprovalSearch.by_params(r2)).not_to include lr1
      end

      it "should include requests that prior reviewers haven't reviewed yet if filter: 'upcoming'" do
        expect(ApprovalSearch.by_params(r2, { filter: 'upcoming' })).to include lr1
      end

      it "should include requests that prior reviewers have accepted" do
        expect(ApprovalSearch.by_params(r2)).to include lr2
      end
    end
  end

  describe 'delgator_approvals_for' do
    let(:u) { create :complete_user_with_delegate }
    let(:d) { u.delegates.first }
    let!(:lr) { create :leave_request, :accepted, user: u }
    let!(:tr) { create :travel_request, :submitted, user: u }
    let!(:gftr) { create :gf_travel_request, user: u }

    it 'should return a list of approvals for the delegator user' do
      expect(ApprovalSearch.delegator_approvables_for(d)).to include lr
      expect(ApprovalSearch.delegator_approvables_for(d)).to include tr
      expect(ApprovalSearch.delegator_approvables_for(d)).to include gftr
    end

    it 'should sort by updated_at desc' do
      # touch lr so that lr.updated_at > tr.updated_at
      lr.update!(desc: "I've been updated!")
      expect(ApprovalSearch.delegator_approvables_for(d)).to eq [lr, gftr, tr]
    end
  end
end
