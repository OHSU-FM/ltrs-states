FactoryGirl.define do
  factory :approval_state do
    user

    trait :leave do
      association :approvable, factory: :leave_request
    end

    factory :leave_approval_state, traits: [:leave]
  end
end
