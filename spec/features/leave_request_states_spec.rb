require "rails_helper"

RSpec.feature "leave_request states", type: :feature do
  scenario "user creates a new leave_request" do
    # user = create :user
    login_user
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
    expect(page).to have_selector(:link_or_button, "unopened")
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

  scenario "full leave request cycle (user w one reviewer)" do
    request = create :leave_request, :submitted
    user = request.user
    visit leave_request_path(request)

    expect(page).to have_text("submitted state")

    click_button 'Send_to_unopened'
    expect(page).to have_text("unopened state")

    click_button 'Review'
    expect(page).to have_text(user.reviewers.first.approver.full_name)

    click_button 'Accept'
    expect(page).to have_text(user.notifiers.first.approver.full_name)
  end

  scenario "full leave request cycle (user w two reviewers)" do
    request = create :leave_request, :submitted, :two_reviewers
    user = request.user
    visit leave_request_path(request)

    expect(page).to have_text("submitted state")

    click_button 'Send_to_unopened'
    expect(page).to have_text("unopened state")

    click_button 'Review'
    expect(page).to have_text(user.reviewers.first.approver.full_name)

    click_button 'Accept'
    expect(page).to have_text(user.reviewers.second.approver.full_name)

    click_button 'Review'
    expect(page).to have_text(user.reviewers.second.approver.full_name)

    click_button 'Accept'
    expect(page).to have_text(user.notifiers.first.approver.full_name)
  end
end
