require 'rails_helper'

RSpec.describe UserApprover, type: :model do
  let(:ua) { create :user_approver }

  describe 'validations' do
    it 'requires a user' do
      expect(build(:user_approver, user: nil)).not_to be_valid
    end

    it 'requires an approver' do
      expect(build(:user_approver, approver_id: nil)).not_to be_valid
    end

    it 'requires an approver_type' do
      expect(build(:user_approver, approver_type: nil)).not_to be_valid
    end

    it 'requires an approver_order' do
      expect(build(:user_approver, approval_order: nil)).not_to be_valid
    end

     it 'requires a sensical approval_order' do
       expect(build(:user_approver, approval_order: 9001)).not_to be_valid
     end
  end

  describe 'methods' do
    it '#approver returns the approver user' do
      expect(ua.approver).to be_a User
    end

    it '#reviewer? returns true if the user_approver is a reviewer' do
      ua = create :user_reviewer
      expect(ua.reviewer?).to be_truthy

      ua = create :user_approver
      expect(ua.reviewer?).to be_falsey
    end

    it '#notifier? returns true if the user_approver is a notifier' do
      ua = create :user_notifier
      expect(ua.notifier?).to be_truthy

      ua = create :user_approver
      expect(ua.notifier?).to be_falsey
    end

    it '#name returns the approver full_name' do
      ua = create :user_approver
      expect(ua.name).to eq ua.approver.full_name
    end
  end
end
