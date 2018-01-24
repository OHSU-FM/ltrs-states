require "rails_helper"

# RSpec.feature "gf travel request new", type: :feature do
#   fdescribe "delegate pov" do
#     before(:each) do
#       @u = create :complete_user_with_delegate
#       @d = @u.delegates.first
#       @d.update!(password: 'password') # doesn't work from factory?
#       visit new_user_session_path
#
#       fill_in 'Username', with: @d.login
#       fill_in 'Password', with: @d.password
#       click_button 'Sign in'
#     end
#
#     scenario "user creates a new gf_travel_request" do
#       visit new_grant_funded_travel_request_path
#
#       expect(page).to have_content "Departure date:"
#       valid_attrs = attributes_for :gf_travel_request
#       fill_form :grant_funded_travel_request, :new, valid_attrs
#       click_button 'Save & Review'
#     end
#   end
# end
