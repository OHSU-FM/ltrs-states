require 'rails_helper'

RSpec.describe UserApprover, type: :model do
  let(:ua) { create :user_approver_full }

  describe 'validations' do
    it 'requires a user' do
      expect( build(:user_approver, user: nil) ).not_to be_valid
    end
  end

  describe 'methods' do
    it '#approver returns the approver user' do
      expect(ua.approver).to be_a User
    end

    it '#reviewer? returns true if the user_approver is a reviewer' do
      ua = create :user_approver, approver_type: 'reviewer'
      expect(ua.reviewer?).to be_truthy

      ua = create :user_approver_full
      expect(ua.reviewer?).to be_falsey
    end

    it '#notifier? returns true if the user_approver is a notifier' do
      ua = create :user_approver, approver_type: 'notifier'
      expect(ua.notifier?).to be_truthy

      ua = create :user_approver_full
      expect(ua.notifier?).to be_falsey
    end
  end
end
