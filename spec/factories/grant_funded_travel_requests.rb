FactoryGirl.define do
  factory :gf_travel_request, class: GrantFundedTravelRequest do
    dest_desc 'description'
    depart_date { 1.day.from_now }
    return_date { 2.days.from_now }
    business_purpose_desc 'site visit'
    expense_card_use false
    air_use false
    car_rental false
    registration_reimb false
    lodging_reimb false
    ground_transport false
    form_email 'email'
    form_user 'user'
    user

    trait :submitted do
      after :create do |gf_travel_request|
        gf_travel_request.approval_state.submit!
      end
    end
    factory :submitted_gf_travel_request, traits: [:submitted]

    trait :unopened do
      after :create do |gf_travel_request|
        gf_travel_request.approval_state.submit!
        gf_travel_request.approval_state.send_to_unopened!
      end
    end

    trait :in_review do
      association :user, factory: :user_with_approvers
      after :create do |gf_travel_request|
        gf_travel_request.approval_state.submit!
        gf_travel_request.approval_state.send_to_unopened!
        gf_travel_request.approval_state.review!
      end
    end

    trait :accepted do
      association :user, factory: :user_with_approvers
      after :create do |gftr|
        gftr.approval_state.submit!
        gftr.approval_state.send_to_unopened!
        gftr.approval_state.review!
        gftr.approval_state.accept!
      end
    end

    # requires user association, but many other traits do that already.
    # so, this probably won't work unless paired with one of those traits.
    trait :with_rr do
      after :create do |gftr|
        ReimbursementRequest.create!(user: gftr.user,
                                     gf_travel_request: gftr,
                                     depart_date: gftr.depart_date,
                                     return_date: gftr.return_date,
                                     form_user: gftr.form_user,
                                     form_email: gftr.form_email)
      end
    end
  end
end
