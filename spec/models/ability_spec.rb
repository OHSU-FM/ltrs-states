require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'admin' do
    let(:user) { create :admin }
    let(:second_user) { create :user }

    describe 'actions' do
      it { is_expected.to be_able_to(:manage, user) }
      it { is_expected.to be_able_to(:manage, second_user) }
    end
  end

  describe 'user' do
    let(:user) { create :user }

    describe 'actions' do
      it { is_expected.to be_able_to(:modify, user) }
      it { is_expected.to be_able_to(:create, LeaveRequest) }
      it { is_expected.to be_able_to(:create, TravelRequest) }
      it { is_expected.to be_able_to(:create, GrantFundedTravelRequest) }
      it { is_expected.to be_able_to(:create, ReimbursementRequest) }
    end

    describe 'owned requests' do
      context "LeaveRequest" do
        let(:request) { create :leave_request, user: user }

        it { is_expected.to be_able_to(:submit, request.approval_state) }
        it { is_expected.to be_able_to(:read, request) }
        it { is_expected.to be_able_to(:destroy, request) }
      end

      context "TravelRequest" do
        let(:request) { create :travel_request, user: user }

        it { is_expected.to be_able_to(:submit, request.approval_state) }
        it { is_expected.to be_able_to(:read, request) }
        it { is_expected.to be_able_to(:destroy, request) }
      end

      context "GrantFundedTravelRequest" do
        let(:request) { create :gf_travel_request, user: user }

        it { is_expected.to be_able_to(:submit, request.approval_state) }
        it { is_expected.to be_able_to(:read, request) }
        it { is_expected.to be_able_to(:destroy, request) }
      end

      context "ReimbursementRequest" do
        let(:request) { create :reimbursement_request, user: user }

        it { is_expected.to be_able_to(:submit, request.approval_state) }
        it { is_expected.to be_able_to(:read, request) }
        it { is_expected.to be_able_to(:edit, request) }
        it { is_expected.to be_able_to(:update, request) }
        it { is_expected.to be_able_to(:destroy, request) }
      end
    end

    describe 'other requests' do
      let(:lr) { create :leave_request }
      let(:tr) { create :travel_request }
      let(:gftr) { create :gf_travel_request }
      let(:rr) { create :reimbursement_request }

      it { is_expected.not_to be_able_to(:read, lr) }
      it { is_expected.not_to be_able_to(:read, tr) }
      it { is_expected.not_to be_able_to(:read, gftr) }
      it { is_expected.not_to be_able_to(:read, rr) }
    end
  end

  describe 'reviewer' do
    let(:reviewed_user) { create :user_with_approvers }
    let(:user) { reviewed_user.reviewers.first.approver }
    let(:request) { create :leave_request, user: reviewed_user }
    let(:state) { request.approval_state }

    describe 'actions' do
      it { is_expected.to be_able_to(:read, request) }
      it { is_expected.to be_able_to(:destroy, request) }
      it { is_expected.to be_able_to(:update, state) }
      it { is_expected.to be_able_to(:review, state) }
      it { is_expected.to be_able_to(:accept, state) }
      it { is_expected.to be_able_to(:reject, state) }
    end
  end

  describe 'new user' do
    let(:user) { build :user }

    describe 'actions' do
      it { is_expected.not_to be_able_to(:modify, LeaveRequest) }
    end
  end
end
