FactoryGirl.define do
  factory :meal_reimbursement_request do
    reimb_date "2017-08-04"
    breakfast false
    lunch false
    dinner false

    reimbursement_request
  end
end
