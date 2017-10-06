FactoryGirl.define do
  factory :funding_source do
    pi "MyString"
    title "MyString"
    start_date Date.yesterday
    end_date Date.tomorrow
  end
end
