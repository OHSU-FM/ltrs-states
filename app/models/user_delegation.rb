class UserDelegation < ApplicationRecord
  belongs_to :user
  belongs_to :delegate_user, class_name: 'User'

  delegate :full_name, :email, to: :delegate_user, allow_nil: true
end
