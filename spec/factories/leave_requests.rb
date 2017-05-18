FactoryGirl.define do
  factory :leave_request do
    association :user, factory: :user_with_approvers

    trait :submitted do
      after :create do |leave_request|
        leave_request.approval_state.update!(aasm_state: "submitted")
      end
    end

    trait :unopened do
      after :create do |leave_request|
        leave_request.approval_state.update!(aasm_state: "unopened")
      end
    end
  end
end
