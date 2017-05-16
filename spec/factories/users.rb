FactoryGirl.define do
  factory :user do
    login 'test'
    first_name 'test'
    last_name 'user'
    email 'test@example.com'
  end
end
