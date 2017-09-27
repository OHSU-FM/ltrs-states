FactoryGirl.define do
  factory :user_approver do
    user
    association :approver, factory: :user
    approver_type 'approver'
    approval_order 1

    factory :user_reviewer do
      approver_type 'reviewer'
    end

    factory :user_notifier do
      approver_type 'notifier'
    end
  end
end
