FactoryBot.define do
  factory :leave_request_extra do
    leave_request
    work_days 1
    work_hours 1.0
    basket_coverage true
  end
end
