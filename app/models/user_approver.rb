class UserApprover < ApplicationRecord
  belongs_to :user
  belongs_to :approver, class_name: 'User', foreign_key: :approver_id

  validates :approver_type, :approval_order, presence: true
  validates :approval_order, inclusion: { in: :approval_order_enum }

  delegate :full_name, :email, to: :approver, allow_nil: true

  has_paper_trail

  MAX_CONTACTS = 10

  #:nocov:
  rails_admin do
    edit do
      include_all_fields

      field :approver_type, :enum do
        enum do
          ['reviewer', 'notifier']
        end
      end
      field :approval_order, :enum do
        enum_method do
          :approval_order_enum
        end
      end
    end
  end
  #:nocov:

  def reviewer?
    approver_type == 'reviewer'
  end

  def notifier?
    approver_type == 'notifier'
  end

  # for rails_admin
  def name
    full_name
  end

  def approval_order_enum
      return (1..5).to_a
  end

  def role_id_enum
    ['reviewer', 'notifier']
  end
end
