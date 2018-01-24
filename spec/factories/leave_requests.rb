FactoryBot.define do
  factory :leave_request do
    association :user, factory: :user_with_approvers
    hours_vacation 1
    start_date DateTime.now.tomorrow.to_date
    end_date DateTime.now.tomorrow.to_date + 1.day

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

    # for use w two_reviewers trait
    trait :back_to_unopened do
      after :create do |leave_request|
        leave_request.approval_state.submit!
        leave_request.approval_state.send_to_unopened!
        leave_request.approval_state.review!
        leave_request.approval_state.send_to_unopened!
      end
    end

    trait :two_reviewers do
      association :user, factory: :user_two_reviewers
    end

    trait :with_extra do
      has_extra true

      after :create do |leave_request|
        create :leave_request_extra, leave_request: leave_request
      end
    end
  end
end
