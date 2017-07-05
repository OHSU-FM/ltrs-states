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
    let(:user) { create :user_with_approvers }

    describe 'actions' do
      it { is_expected.to be_able_to(:modify, user) }
      it { is_expected.to be_able_to(:create, LeaveRequest) }
      it { is_expected.to be_able_to(:create, TravelRequest) }
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
    end
  end

  describe 'new user' do
    let(:user) { build :user }

    describe 'actions' do
      it { is_expected.not_to be_able_to(:modify, LeaveRequest) }
    end
  end
end
