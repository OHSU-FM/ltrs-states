FactoryGirl.define do
  factory :approval_state do
    user

    trait :leave do
      association :approvable, factory: :leave_request
    end

    trait :submitted do
      after(:create) do | as | 
      	as.submit!
      	byebug
      end
    end

    factory :leave_approval_state, traits: [:leave]
    factory :submitted_leave_approval_state, traits: [:submitted, :leave]
  end
end
