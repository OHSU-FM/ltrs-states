# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def request_submitted
    state = ApprovalState.where(aasm_state: 'submitted').first
    state = FactoryBot.create(:leave_request, :submitted, user: User.first).approval_state if state.nil?
    UserMailer.request_submitted(state)
  end

  def request_rejected
    state = ApprovalState.where(aasm_state: 'rejected').first
    state = FactoryBot.create(:leave_request, :rejected, user: User.first).approval_state if state.nil?
    UserMailer.request_rejected(state)
  end

  def request_accepted
    UserMailer.request_accepted(ApprovalState.where(aasm_state: 'accepted').first)
  end

  def leave_request
    state = ApprovalState.where(approvable_type: 'LeaveRequest').where.not(aasm_state: ['in_review', 'unsubmitted', 'unopened', 'expired', 'rejected']).first
    state = FactoryBot.create(:leave_request, :submitted, user: User.first).approval_state if state.nil?
    UserMailer.send("request_#{state.aasm_state}".to_sym, state)
  end

  def travel_request
    state = ApprovalState.where(approvable_type: 'TravelRequest').where.not(aasm_state: ['in_review', 'unsubmitted', 'unopened', 'expired', 'rejected']).first
    state = FactoryBot.create(:travel_request, :submitted, user: User.first).approval_state if state.nil?
    UserMailer.send("request_#{state.aasm_state}".to_sym, state)
  end

  def grant_funded_travel_request
    state = ApprovalState.where(approvable_type: 'GrantFundedTravelRequest').where.not(aasm_state: ['in_review', 'unsubmitted', 'unopened']).first
    state = FactoryBot.create(:gf_travel_request, :submitted, user: User.find_by(login: 'grant')).approval_state if state.nil?
    UserMailer.send("request_#{state.aasm_state}".to_sym, state)
  end

  def reimbursement_request
    state = ApprovalState.where(approvable_type: 'ReimbursementRequest').where.not(aasm_state: ['in_review', 'unsubmitted', 'unopened']).first
    state = FactoryBot.create(:reimbursement_request, :submitted, user: User.find_by(login: 'grant')).approval_state if state.nil?
    UserMailer.send("request_#{state.aasm_state}".to_sym, state)
  end

  def reimbursement_request_available
    req = ReimbursementRequest.last
    req = FactoryBot.create(:reimbursement_request, user: User.find_by(login: 'grant')) if req.nil?
    UserMailer.send('reimbursement_request_available', req.gf_travel_request.approval_state)
  end
end
