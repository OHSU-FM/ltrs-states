class LeaveRequestExtra < ApplicationRecord
  has_paper_trail
  belongs_to :leave_request
end
