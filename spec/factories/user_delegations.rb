FactoryGirl.define do
  factory :user_delegation do
    user
    association :delegate_user, factory: :user
  end
end
