module Users::FormsHelper
  STATES = {
      'unsubmitted'  => '',
      'submitted'    => 'info',
      'unopened'     => 'info',
      'in_review'    => 'info',
      'missing_info' => 'info',
      'rejected'     => 'danger',
      'expired'      => 'danger',
      'approved'     => 'info',
      'complete'     => 'success',
      'error'        => 'danger'
  }

  def hf_row_status approval_state
    STATES[approval_state.aasm_state]
  end

  def hf_forms_title
    return 'Delegate forms' if action_name == 'delegate_forms'
    return 'My Forms' if (current_user.id == @user.id)
    return "Forms for #{@user.full_name}" if action_name == 'index'
  end
end
