FactoryGirl.define do
  factory :user do
    login 'test'
    first_name 'test'
    last_name 'user'
    email 'test@example.com'

    factory :user_with_approvers do
      after(:create) do |user|
        reviewer = create :user, first_name: 'reviewer', email: 'reviewer@example.com'
        notifier = create :user, first_name: 'notifier', email: 'notifier@example.com'
        create :user_approver, user: user, approver_id: notifier.id, approver_type: 'notifier', approval_order: 2
        create :user_approver, user: user, approver_id: reviewer.id, approver_type: 'reviewer', approval_order: 1
        user.reload
      end
    end
  end
end
