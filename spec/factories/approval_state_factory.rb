FactoryGirl.define do
  factory :approval_state do
    association :user, factory: :user_with_approvers

    trait :leave do
      after(:build) do |as|
        lr = create :leave_request, user: as.user
        as.approvable = lr
        lr.approval_state = as
        lr.save!
      end
    end

    factory :leave_approval_state, traits: [:leave]

    trait :in_review do
      after(:create) do |as|
        as.submit!
        as.send_to_unopened!
        as.review!
      end
    end

    trait :two_reviewers do
      association :user, factory: :user_two_reviewers
    end
  end
end
