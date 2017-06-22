FactoryGirl.define do
  factory :leave_request do
    association :user, factory: :user_with_approvers

    trait :submitted do
      after :create do |leave_request|
        leave_request.approval_state.submit!
      end
    end
    factory :submitted_leave_request, traits: [:submitted]

    trait :unopened do
      after :create do |leave_request|
        leave_request.approval_state.submit!
        leave_request.approval_state.send_to_unopened!
      end
    end

    trait :in_review do
      after :create do |leave_request|
        leave_request.approval_state.submit!
        leave_request.approval_state.send_to_unopened!
        leave_request.approval_state.review!
      end
    end

    trait :rejected do
      after :create do |leave_request|
        leave_request.approval_state.submit!
        leave_request.approval_state.send_to_unopened!
        leave_request.approval_state.review!
        leave_request.approval_state.reject!
      end
    end

    trait :accepted do
      after :create do |leave_request|
        leave_request.approval_state.submit!
        leave_request.approval_state.send_to_unopened!
        leave_request.approval_state.review!
        leave_request.approval_state.accept!
      end
    end

    trait :two_reviewers do
      association :user, factory: :user_two_reviewers
    end

    trait :with_travel_request do
      after(:create) do |lr|
        create :travel_request, user: lr.user, leave_request: lr
      end
    end
  end
end
