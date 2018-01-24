FactoryBot.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:login) { |n| "user#{n}" }
  factory :user do
    login
    first_name 'test'
    last_name 'user'
    email
    password 'password'
    is_ldap false

    factory :user_with_approvers, traits: [:with_approvers]

    factory :user_two_reviewers do
      transient do
        reviewer1 nil
        reviewer2 nil
        notifier nil
      end

      after(:create) do |user, evaluator|
        reviewer1 = evaluator.reviewer1 || create(:user,
                                                  first_name: 'reviewer1',
                                                  email: "reviewer14u#{user.id}@example.com")
        reviewer2 = evaluator.reviewer2 || create(:user,
                                                  first_name: 'reviewer2',
                                                  email: "reviewer24u#{user.id}@example.com")
        notifier = evaluator.notifier || create(:user,
                                                first_name: 'notifier',
                                                email: "notifier4u#{user.id}@example.com")
        create :user_approver,
          user: user,
          approver_id: notifier.id,
          approver_type: 'notifier',
          approval_order: 3
        create :user_approver,
          user: user,
          approver_id: reviewer1.id,
          approver_type: 'reviewer',
          approval_order: 1
        create :user_approver,
          user: user,
          approver_id: reviewer2.id,
          approver_type: 'reviewer',
          approval_order: 2
        user.reload
      end
    end

    trait :with_delegate do
      after(:create) do |user|
        d = create :user_with_approvers,
          first_name: 'delegate',
          login: 'delegate',
          email: "delegate4u#{user.id}@example.com"
        create :user_delegation, user: user, delegate_user: d
      end
    end

    factory :user_with_delegate, traits: [:with_delegate]
    factory :complete_user_with_delegate, traits: [:with_approvers, :with_delegate]

    factory :admin do
      is_admin true
    end

    factory :user_no_ldap do
      is_ldap false
      password 'password'
    end

    trait :with_approvers do
      transient do
        reviewer_user nil
      end
      password 'password'

      after(:create) do |user, evaluator|
        reviewer = evaluator.reviewer_user || create(:user,
                                                     first_name: 'reviewer',
                                                     email: "reviewer4u#{user.id}@example.com",
                                                     is_ldap: false,
                                                     password: 'password')
        notifier = create :user,
          first_name: 'notifier',
          email: "notifier4u#{user.id}@example.com"
        create :user_approver,
          user: user,
          approver_id: notifier.id,
          approver_type: 'notifier',
          approval_order: 2
        create :user_approver,
          user: user,
          approver_id: reviewer.id,
          approver_type: 'reviewer',
          approval_order: 1
        user.reload
      end
    end

    trait :with_profile do
      dob '11-22-1990'
      cell_number '111-222-3333'
      ecn1 'ecn1'
      ecp1 '444-555-6666'
      ecn2 'ecn2'
      ecp2 '777-888-9999'
      dietary_restrictions 'restr'
      ada_accom 'accom'
      air_seat_pref 'aisle'
      hotel_room_pref 'pref'
      tsa_pre 'number'
      legal_name 'george'

      after :create do |u|
        u.ff_numbers = create_list(:ff_number, 1)
      end
    end

    factory :user_with_profile, traits: [:with_profile]
  end
end
