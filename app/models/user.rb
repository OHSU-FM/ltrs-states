class User < ApplicationRecord
  has_many :approval_states

  validates_presence_of :login
end
