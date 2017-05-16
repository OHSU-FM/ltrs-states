FactoryGirl.define do
  factory :user do
    login 'test'
    first_name 'test'
    last_name 'user'
    email 'test@example.com'

    trait :with_approvers do
      after(:create) do |user, evaluator|
        user.user_approvers << create(:user_approver, approval_order: 1)
        user.user_approvers << create(:user_approver, approval_order: 2)
      end
    end
  end
end
