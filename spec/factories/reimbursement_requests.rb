FactoryGirl.define do
  factory :reimbursement_request do
    depart_date { 1.day.from_now }
    return_date { 2.days.from_now }
    form_email 'email'
    form_user 'user'
    user
    gf_travel_request

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

    trait :error do
      association :user, factory: :user_with_approvers
      after(:create) do |rr|
        rr.approval_state.update(aasm_state: 'error')
      end
    end

    trait :with_uf do
      transient do
        document_type "Itinerary"
      end

      after(:create) do |rr, evaluator|
        create_list(:full_user_file, 1, fileable: rr, document_type: evaluator.document_type)
      end
    end
  end
end
