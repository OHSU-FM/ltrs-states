class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new                   # guest user (not logged in)

    alias_action :create, :read, :update, to: :modify
    alias_action :delete, to: :destroy

    if user.is_admin?
      admin_user_permissions
    else
      normal_user_permissions user
    end
  end

  def admin_user_permissions
    can :access, :rails_admin
    can :dashboard
    can :manage, :all
  end

  def normal_user_permissions user
    can :modify, User, id: user.id

    unless user.new_record?
      can :create, LeaveRequest
      can :create, TravelRequest
    end

    can [:read, :destroy], LeaveRequest do |lr|
      lr.user == user || user.reviewable_users.include?(lr.user)
    end

    can [:read, :destroy], TravelRequest do |tr|
      tr.user == user || user.reviewable_users.include?(tr.user)
    end

    can :update, ApprovalState do |as|
      as.user == user || user.reviewable_users.include?(as.user)
    end

    can :submit, LeaveRequest do |lr|
      lr.user == user
    end

    can [:review, :accept, :reject], LeaveRequest do |lr|
      as.user.reviewers.map(&:approver).include? user
    end

    can :submit, TravelRequest do |tr|
      tr.user == user
    end

    can [:review, :accept, :reject], TravelRequest do |tr|
      tr.user.reviewers.map(&:approver).include? user
    end
  end
#     controllable_user_ids = user.controllable_users.map{|u|u.id}
#     controllable_user_emails = user.controllable_users.map{|u|u.email}
#     viewable_user_ids = user.viewable_users.map{|u|u.id}
#     approvable_user_ids = user.approvable_users.map{|u|u.id}
#
#     can :read, UserFile, ['user_id IN (?)', viewable_user_ids] do |user_file|
#       viewable_user_ids.include?(user_file.user_id)
#     end
#
#     can :update, ApprovalState do |approval_state|
#       approvable_user_ids.include? approval_state.approvable.user_id
#     end
#
#     can :modify, LeaveRequest, ['user_id in (?) OR form_email in (?)', controllable_user_ids, controllable_user_emails] do |leave_request|
#       controllable_user_ids.include?(leave_request.user_id) || controllable_user_emails.include?(leave_request.form_email)
#     end
#
#     can :modify, TravelRequest, ['user_id in (?) OR form_email in (?)', controllable_user_ids, controllable_user_emails] do |leave_request|
#       controllable_user_ids.include?(leave_request.user_id) || controllable_user_emails.include?(leave_request.form_email)
#     end
#
#     unless user.new_record?
#       can :create, LeaveRequest
#       can :create, TravelRequest
#     end
#
#     can :read, TravelRequest, ['user_id IN (?)', viewable_user_ids] do |travel_request|
#       viewable_user_ids.include? travel_request.user_id
#     end
#
#     can :read, LeaveRequest, ['user_id in (?)', viewable_user_ids] do |leave_request|
#       viewable_user_ids.include? leave_request.user_id
#     end
#
#     can :destroy, TravelRequest do |rec|
#       controllable_user_ids.include?(rec.user_id) && can_cancel_request?(rec) #############
#     end
#
#     can :destroy, LeaveRequest do |rec|
#       controllable_user_ids.include?(rec.user_id) && can_cancel_request?(rec) ##############
#     end
#
#
#     if user.view_admin
#       can :access, :rails_admin
#       can :dashboard
#
#       can :export, ApprovalState
#       can :export, UserFile
#       can :export, TravelRequest
#       can :export, LeaveRequest
#       can :export, User
#
#       can :read, ApprovalState
#       can :read, UserFile
#       can :read, TravelRequest
#       can :read, LeaveRequest
#       can :read, User
#       can :show_from_app, TravelRequest
#       can :show_from_app, LeaveRequest
#       can :show_from_app, User
#     end
#
  end
#
#   '''
# -- Allow request to be canceled only if it has been submitted. Allow to be deleted otherwise.
# -- Request created...
#     -- created?
#         -- N - Not allowed
#         -- Y - Next
#     -- Submitted?
#         -- Y - Rejected?
#             -- N - Allow cancel - Notify everyone
#             -- Y - Cancel disabled
#         -- N - Allow delete
#   '''
#   def can_cancel_request? request
#     return false if request.new_record? # cannot destroy new
#     approval_state = request.approval_state
#     # can destroy unsubmitted
#     return true if approval_state && approval_state.status == ApprovalState::STATE_STRINGS['unsubmitted']
#     # cannot destroy rejected
#     return true if approval_state && approval_state.status != ApprovalState::STATE_STRINGS['rejected']
#     return false
#   end
