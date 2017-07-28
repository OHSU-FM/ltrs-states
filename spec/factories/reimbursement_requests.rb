FactoryGirl.define do
  factory :reimbursement_request do
    depart_date { 1.day.from_now }
    return_date { 2.days.from_now }
    form_email 'email'
    form_user 'user'
    user

    trait :submitted do
      after :create do |reimbursement_request|
        reimbursement_request.approval_state.submit!
      end
    end
    factory :submitted_reimbursement_request, traits: [:submitted]

    trait :unopened do
      after :create do |reimbursement_request|
        reimbursement_request.approval_state.submit!
        reimbursement_request.approval_state.send_to_unopened!
      end
    end

    trait :in_review do
      association :user, factory: :user_with_approvers
      after :create do |reimbursement_request|
        reimbursement_request.approval_state.submit!
        reimbursement_request.approval_state.send_to_unopened!
        reimbursement_request.approval_state.review!
      end
    end
  end
end
