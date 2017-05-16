class User < ApplicationRecord
  has_many :approval_states

  validates_presence_of :login

  def full_name
    "#{ first_name } #{ last_name }"
  end
end
