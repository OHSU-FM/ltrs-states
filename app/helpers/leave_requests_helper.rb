module LeaveRequestsHelper
  def button_to_state_path state
    "#{state.to_s}_leave_request_path"
  end
end
