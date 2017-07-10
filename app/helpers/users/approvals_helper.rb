module Users::ApprovalsHelper

  FILTER_OPTS = {
    None: 'none',
    Past: 'past',
    Upcoming: 'upcoming',
    Pending: 'pending',
    Unsubmitted: 'unsubmitted'
  }

  def hf_filter
    val = params[:filter].to_s
    title = FILTER_OPTS.values.include?(val) ? val : 'all'
    title == 'none' ? 'all' : title
  end

  def hf_filter_description filter_name
    case filter_name
      when 'past'
       'These are the requests that you have accepted/rejected.'
      when 'active'
       'These are the requests that you have approved that are still awaiting final approval.'
      when 'upcoming'
       'These are the requests that have been submitted but do not yet require your approval.'
      when 'pending'
       'These are the requests that are waiting for your approval.'
      when 'unsubmitted'
        'These are the requests that have not been submitted.'
      else
        'Selecting from all approvals'
    end
  end

  def hf_approval_state_permitted_options approval_state
    states = approval_state.aasm.states(permitted: true).map(&:name).map(&:to_s).map(&:humanize)
    events = approval_state.aasm.events(permitted: true).map(&:name).map(&:to_s)
    current = [approval_state.aasm_state].map{|c| [c.humanize, c]}
    return (states.zip(events) + current)
  end
end
