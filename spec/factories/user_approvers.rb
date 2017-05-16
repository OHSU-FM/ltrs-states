FactoryGirl.define do
  factory :user_approver do
    user
    approval_order 1

    after(:create) do |user_approver, evaluator|
      approver = create :user
      user_approver.approver_id = approver.id
      user_approver.approver_type = 'test_approver'
      user_approver.save!
    end
  end
end
