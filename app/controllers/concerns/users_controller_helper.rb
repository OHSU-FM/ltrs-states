module Concerns::UsersControllerHelper
  def hf_can_read_profile? user, uid
    user.delegators.map(&:id).map(&:to_s).include?(uid) || user.id.to_s == uid
  end
end
