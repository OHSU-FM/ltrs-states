class UserDelegation < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :delegate_user, -> { with_deleted }, class_name: 'User'

  delegate :name, :full_name, :email, to: :delegate_user, allow_nil: true
end
