FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:login) { |n| "user#{n}" }
  factory :user do
    login
    first_name 'test'
    last_name 'user'
    email

    factory :user_with_approvers, traits: [:with_approvers]

    factory :user_two_reviewers do
      after(:create) do |user|
        reviewer1 = create :user, first_name: 'reviewer1', email: "reviewer14u#{user.id}@example.com"
        reviewer2 = create :user, first_name: 'reviewer2', email: "reviewer24u#{user.id}@example.com"
        notifier = create :user, first_name: 'notifier', email: "notifier4u#{user.id}@example.com"
        create :user_approver, user: user, approver_id: notifier.id, approver_type: 'notifier', approval_order: 3
        create :user_approver, user: user, approver_id: reviewer1.id, approver_type: 'reviewer', approval_order: 1
        create :user_approver, user: user, approver_id: reviewer2.id, approver_type: 'reviewer', approval_order: 2
        user.reload
      end
    end

    factory :user_with_delegate do
      after(:create) do |user|
        d = create :user, first_name: 'delegate', email: "delegate4u#{user.id}@example.com"
        create :user_delegation, user: user, delegate_user: d
      end
    end

    factory :admin do
      is_admin true
    end

    factory :user_no_ldap do
      is_ldap false
      password 'password'
    end

    trait :with_approvers do
      transient do
        reviewer_user nil
      end

      after(:create) do |user, evaluator|
        reviewer = evaluator.reviewer_user || create(:user, first_name: 'reviewer', email: "reviewer4u#{user.id}@example.com", is_ldap: false, password: 'password')
        notifier = create :user, first_name: 'notifier', email: "notifier4u#{user.id}@example.com"
        create :user_approver, user: user, approver_id: notifier.id, approver_type: 'notifier', approval_order: 2
        create :user_approver, user: user, approver_id: reviewer.id, approver_type: 'reviewer', approval_order: 1
        user.reload
      end
    end
  end
end
