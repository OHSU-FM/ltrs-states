FactoryGirl.define do
  factory :user do
    login 'test'
    first_name 'test'
    last_name 'user'
    sequence :email do |n|
      "user#{n}@example.com"
    end

    factory :user_with_approvers do
      after(:create) do |user|
        reviewer = create :user, first_name: 'reviewer', email: "reviewer4u#{user.id}@example.com"
        notifier = create :user, first_name: 'notifier', email: "notifier4u#{user.id}@example.com"
        create :user_approver, user: user, approver_id: notifier.id, approver_type: 'notifier', approval_order: 2
        create :user_approver, user: user, approver_id: reviewer.id, approver_type: 'reviewer', approval_order: 1
        user.reload
      end
    end

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

    factory :admin do
      is_admin true
    end
  end
end
