require "rails_helper"

RSpec.feature "leave_request states", type: :feature do

  describe "user pov" do
    before(:each) do
      @u = create :user_no_ldap, :with_approvers
      visit new_user_session_path

      fill_in 'Username', with: @u.login
      fill_in 'Password', with: @u.password
      click_button 'Sign in'
    end

    scenario "user creates a new leave_request" do
      visit new_leave_request_path

      fill_in 'First day of leave', with: 1.day.from_now
      fill_in 'Last day of leave', with: 2.day.from_now
      fill_in 'Vacation Hours', with: 1.0
      first(:button, "Save & Review").click

      expect(page).to have_text("was successfully created.")
      expect(page).to have_text("don't forget to submit it!")
    end

    scenario "user submits a request" do
      leave_request = create :leave_request, user: @u
      visit leave_request_path(leave_request)

      first(:button, "Submit").click

      expect(page).to have_text("submitted")
    end
  end

  describe 'reviewer pov' do
    before(:each) do
      u = create :user_with_approvers
      @r = u.reviewers.first.approver
      @r.update!(is_ldap: false, password: 'password')
      @lr = create :leave_request, :unopened, user: u

      visit new_user_session_path
      fill_in 'Username', with: @r.login
      fill_in 'Password', with: @r.password
      click_button 'Sign in'
    end

    scenario "reviewer visits unopened request" do
      visit leave_request_path(@lr)

      expect(@lr.approval_state).to be_in_review
      expect(page).to have_text("In review")
      expect(page).to have_text("Waiting on response from " + @r.full_name)

    end

    scenario "leave_request accept button pressed" do
      visit leave_request_path(@lr)

      find('#approval_state_aasm_state').find(:xpath, 'option[2]').select_option
      click_button('Save')
      expect(@lr.approval_state).to be_accepted

      expect(page).to have_text("Accepted")
    end

    scenario "leave_request reject button pressed" do
      visit leave_request_path(@lr)

      find('#approval_state_aasm_state').find(:xpath, 'option[1]').select_option
      click_button('Save')
      expect(@lr.approval_state).to be_rejected

      expect(page).to have_text("Rejected")
    end
  end
end
