FactoryGirl.define do
  factory :leave_request do
    user

    trait :submitted do
      after :create do |leave_request|
        leave_request.approval_state.update!(aasm_state: "submitted")
      end
    end
  end
end
