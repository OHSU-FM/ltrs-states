class LegacyUser < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'users'

  has_many :legacy_user_approvers, class_name: 'LegacyUserApprover'
end

class LegacyUserApprover < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'user_default_emails'

  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'

  ROLE_ID_CODES = {
    1 => "notifier",
    2 => "reviewer",
    3 => "reviewer"
  }
end

class LegacyLeaveRequest < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'leave_requests'

  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'

  has_one :legacy_approval_state, as: :approvable, dependent: :destroy
  has_one :legacy_leave_request_extra, class_name: 'LegacyLeaveRequestExtra', foreign_key: 'leave_request_id'

  def legacy_approval_state
    LegacyApprovalState.where(approvable_id: self.id, approvable_type: "LeaveRequest").first
  end
end

class LegacyApprovalState < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'approval_states'

  belongs_to :approvable, polymorphic: true
  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'
  has_many :legacy_user_approvers, through: :legacy_user


  STATES = {
    0=>'unsubmitted',              # mail_sent = false
    10=>'submitted',               # mail_sent = true
    20=>'unopened',                 # unopened for review
    30=>'in_review',               # viewed by reviewer
    40=>'missing_information',     # marked by reviewer
    50=>'rejected',                # by reviewer
    51=>'expired',
    60=>'accepted',                # approved by reviewer
    61=>'accepted',       # approved by final reviewer
    999=>'error'
  }
end

class LegacyLeaveRequestExtra < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'leave_request_extras'

  belongs_to :legacy_leave_request, class_name: 'LegacyLeaveRequest', foreign_key: 'leave_request_id'
end

class LegacyTravelRequest < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'travel_requests'

  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'

  has_one :legacy_approval_state, as: :approvable, dependent: :destroy

  def legacy_approval_state
    LegacyApprovalState.where(approvable_id: self.id, approvable_type: "TravelRequest").first
  end
end

class LegacyUserDelegation < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'user_delegations'

  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'
  belongs_to :legacy_delegate, class_name: 'LegacyUser', foreign_key: 'delegate_user_id'
end

class LegacyUserFile < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'user_files'

  belongs_to :legacy_user, class_name: 'LegacyUser', foreign_key: 'user_id'

  has_many :legacy_travel_files
  has_many :legacy_travel_requests, through: :legacy_travel_files
end

class LegacyTravelFile < ActiveRecord::Base
  establish_connection :legacy
  self.table_name = 'travel_files'

  belongs_to :legacy_travel_request, foreign_key: 'travel_request_id'
  belongs_to :legacy_user_file, foreign_key: 'user_file_id'
end
