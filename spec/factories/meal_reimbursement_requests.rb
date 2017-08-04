FactoryGirl.define do
  factory :meal_reimbursement_request do
    reimb_date "2017-08-04"
    breakfast false
    breakfast_desc "MyText"
    lunch false
    lunch_desc "MyText"
    dinner false
    dinner_desc "MyText"

    reimbursement_request
  end
end
