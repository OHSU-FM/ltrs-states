FactoryGirl.define do
  factory :travel_request do
    dest_depart_date { 1.day.from_now }
    ret_depart_date { 2.days.from_now }
    form_email 'email'
    form_user 'user'
    association :user, factory: :user_with_approvers

    trait :submitted do
      after :create do |travel_request|
        travel_request.approval_state.submit!
      end
    end
    factory :submitted_travel_request, traits: [:submitted]

    trait :unopened do
      after :create do |travel_request|
        travel_request.approval_state.submit!
        travel_request.approval_state.send_to_unopened!
      end
    end

    trait :in_review do
      after :create do |travel_request|
        travel_request.approval_state.submit!
        travel_request.approval_state.send_to_unopened!
        travel_request.approval_state.review!
      end
    end

    trait :rejected do
      after :create do |travel_request|
        travel_request.approval_state.submit!
        travel_request.approval_state.send_to_unopened!
        travel_request.approval_state.review!
        travel_request.approval_state.reject!
      end
    end

    trait :accepted do
      after :create do |travel_request|
        travel_request.approval_state.submit!
        travel_request.approval_state.send_to_unopened!
        travel_request.approval_state.review!
        travel_request.approval_state.accept!
      end
    end
  end
end
