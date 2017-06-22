FactoryGirl.define do
  factory :travel_request do
    dest_depart_date { 1.day.from_now }
    ret_depart_date { 2.days.from_now }
    form_email 'email'
    form_user 'user'
    user
    leave_request
  end
end
