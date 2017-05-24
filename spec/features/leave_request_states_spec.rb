require "rails_helper"

RSpec.feature "leave_request states", :type => :feature do
  scenario "user creates a new leave_request" do
    user = create :user
    visit new_leave_request_path

    select user.full_name, from: 'leave_request[user_id]'
    click_button "Create"

    expect(page).to have_text("was successfully created.")
    expect(page).to have_text("unsubmitted")
  end

  scenario "leave_request submit button pressed" do
    leave_request = create :leave_request
    visit leave_request_path(leave_request)

    click_button "Submit"

    expect(page).to have_text("submitted")
    expect(page).to have_selector(:link_or_button, "submitted")
    expect(page).to have_selector(:link_or_button, "Send_to_unopened")
  end

  scenario "leave_request Send_to_unopened button pressed" do
    leave_request = create :leave_request, :submitted
    visit leave_request_path(leave_request)

    click_button "Send_to_unopened"

    expect(page).to have_text("sent_to_unopened")
    expect(page).to have_selector(:link_or_button, "Review")
  end

  scenario "leave_request review button pressed" do
    leave_request = create :leave_request, :unopened
    visit leave_request_path(leave_request)

    click_button "Review"

    expect(page).to have_text("in_review")
    expect(page).to have_selector(:link_or_button, "Reject")
    expect(page).to have_selector(:link_or_button, "Accept")
  end

  scenario "leave_request accept button pressed" do
    leave_request = create :leave_request, :in_review
    visit leave_request_path(leave_request)

    click_button "Accept"

    expect(page).to have_text("accepted")
    expect(page).to have_selector(:link_or_button, "accepted")
  end

  scenario "leave_request reject button pressed" do
    leave_request = create :leave_request, :in_review
    visit leave_request_path(leave_request)

    click_button "Reject"

    expect(page).to have_text("rejected")
    expect(page).to have_selector(:link_or_button, "rejected")
  end

  fscenario "full leave request cycle" do
    user = create :user_with_approvers
    state = create :submitted_leave_approval_state, user: user
    byebug
    visit leave_request_path(state.approvable)

    expect(page).to have_text(user.reviewers.approver.full_name)
  end
end
