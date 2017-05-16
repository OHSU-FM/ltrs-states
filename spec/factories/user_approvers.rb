FactoryGirl.define do
  factory :user_approver do
    user nil
    approver_id 1
    approver_type "MyString"
    approval_order 1
  end
end
