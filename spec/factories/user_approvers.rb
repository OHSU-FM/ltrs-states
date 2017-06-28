FactoryGirl.define do
  factory :user_approver do
    user

    after(:build) do |ua|
      if ua.approver_id.nil?
        approver = create :user, first_name: 'approver'
        ua.approver_id = approver.to_param
        ua.approver_type = 'approver'
      end
    end

    factory :user_reviewer do
      before(:create) do |ua|
        ua.approver_type = "reviewer"
        ua.save!
      end
    end

    factory :user_notifier do
      before(:create) do |ua|
        ua.approver_type = "notifier"
        ua.save!
      end
    end
  end
end
