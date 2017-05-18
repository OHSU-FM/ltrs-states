FactoryGirl.define do
  factory :user_approver do
    user

    factory :user_approver_full do
      after(:create) do |ua|
        ua.approver_id = (create :user, first_name: "approver").to_param
        ua.approver_type = "approver"
        ua.save!
      end
    end
  end
end
