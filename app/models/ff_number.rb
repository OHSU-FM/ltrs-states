class FfNumber < ApplicationRecord
  belongs_to :user

  validates :ffid, :airline, presence: true
end
