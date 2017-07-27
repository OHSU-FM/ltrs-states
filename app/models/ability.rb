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
      can [:create, :submit], LeaveRequest
      can [:create, :submit], TravelRequest
      can [:create, :submit], GrantFundedTravelRequest
    end

    can [:read, :destroy], LeaveRequest do |lr|
      lr.user == user || user.reviewable_users.include?(lr.user)
    end

    can [:read, :destroy], TravelRequest do |tr|
      tr.user == user || user.reviewable_users.include?(tr.user)
    end

    can [:read, :destroy], GrantFundedTravelRequest do |gftr|
      gftr.user == user || user.reviewable_users.include?(gftr.user)
    end

    can :update, ApprovalState do |as|
      as.user == user || user.reviewable_users.include?(as.user)
    end

    can :submit, ApprovalState do |as|
      as.user == user
    end

    can [:review, :accept, :reject], ApprovalState do |as|
      as.user.reviewers.map(&:approver).include? user
    end

    can [:review, :accept, :reject], LeaveRequest do |lr|
      lr.user.reviewers.map(&:approver).include? user
    end

    can [:review, :accept, :reject], TravelRequest do |tr|
      tr.user.reviewers.map(&:approver).include? user
    end

    can [:review, :accept, :reject], GrantFundedTravelRequest do |gftr|
      gftr.user.reviewers.map(&:approver).include? user
    end
  end
end
