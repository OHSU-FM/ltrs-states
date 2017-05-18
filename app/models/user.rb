class User < ApplicationRecord
  has_many :approval_states
  has_many :user_approvers, -> { order('approval_order ASC') }

  validates_presence_of :login

  def full_name
    "#{ first_name } #{ last_name }"
  end
end
