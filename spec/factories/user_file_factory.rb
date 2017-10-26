include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user_file do
    uploaded_file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.jpg')) }

    factory :full_user_file do
      association :fileable, factory: :gf_travel_request, strategy: :build
    end
  end
end
