FactoryGirl.define do
  factory :approval_state do
    user
  end

  factory :leave_approval_state do
    association :approvable, factory: :leave_request
  end
end
