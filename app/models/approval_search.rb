class ApprovalSearch
  include Users::ApprovalsHelper

  FILTER_OPTS_MEANINGS = {
    'none': ['unsubmitted', 'submitted', 'unopened', 'in_review', 'accepted', 'rejected', 'missing_information'],
    'past': ['accepted', 'rejected', 'missing_information'],
    'pending': ['submitted', 'unopened', 'in_review'],
    'upcoming': ['submitted', 'unopened', 'in_review'],
    'unsubmitted': ['unsubmitted']
  }

  def self.by_params user, parameters={}
    ids = user.reviewable_users_ids
    sort_by = SORT_BY_OPTS.values
      .include?(parameters[:sort_by]) ? parameters[:sort_by] : 'created_at'
    sort_order = SORT_ORDER_OPTS.values
      .include?(parameters[:sort_order]) ? parameters[:sort_order] : 'desc'
    f_val = parameters[:filter] || 'pending'
    qq = parameters[:q]
    if qq == "" or qq.nil?
      approvables_by_id(ids, sort_by, sort_order, f_val)
    else
      approvables_by_q(ids, sort_by, sort_order, f_val, qq)
    end
  end

  def self.approvables_by_id ids, sort_by, sort_order, f_val
    lrs = LeaveRequest.includes(:approval_state).where(user_id: ids)
    filtered_lrs = lrs.where("approval_states.aasm_state IN (?)", FILTER_OPTS_MEANINGS[f_val.to_sym])
      .references(:approval_states)
    trs = TravelRequest.includes(:approval_state).where(user_id: ids)
    filtered_trs = trs.where("approval_states.aasm_state IN (?)", FILTER_OPTS_MEANINGS[f_val.to_sym])
      .references(:approval_states)
    gftrs = GrantFundedTravelRequest.includes(:approval_state).where(user_id: ids)
    filtered_gftrs = gftrs.where("approval_states.aasm_state IN (?)", FILTER_OPTS_MEANINGS[f_val.to_sym])
      .references(:approval_states)
    r = (filtered_lrs | filtered_trs | filtered_gftrs).to_a.sort_by{ |r| r.send(sort_by) }
    return sort_order == "desc" ? r.reverse! : r
  end

  def self.approvables_by_q allowable_ids, sort_by, sort_order, f_val, q
    operator = 'or'
    sub_queries = q.split(" ")
    leave_requests, travel_requests, gf_travel_requests = Set.new, Set.new, Set.new

    sub_queries.map(&:downcase).each do |qval|
      # Set join operator and hit next
      if ['and', 'or', 'not'].include?(qval)
        operator = qval
        next
      end

      qv = "%#{qval}%"
      if qval == 'travel'
        trs = TravelRequest.where(user_id: allowable_ids)
        gftrs = GrantFundedTravelRequest.where(user_id: allowable_ids)
        travel_requests = array_join(operator, travel_requests, (trs | gftrs))
        leave_requests = Set.new if operator == 'and'
      elsif qval == 'leave'
        lrs = LeaveRequest.where(user_id: allowable_ids)
        leave_requests = array_join(operator, leave_requests, lrs)
        travel_requests = Set.new if operator == 'and'
        gf_travel_requests = Set.new if operator == 'and'
      else
        lrs = LeaveRequest.includes(:user).where(user_id: allowable_ids)
          .where(
          ["lower(users.email) LIKE ?
             OR lower(users.login) LIKE ?
             OR lower(\"desc\") LIKE ?
             OR lower(form_email) LIKE ?
             OR lower(form_user) LIKE ?", qv, qv, qv, qv, qv]
        ).references(:users)
        leave_requests = array_join(operator, leave_requests, lrs)

        trs = TravelRequest.includes(:user).where(user_id: allowable_ids)
          .where(
          ["lower(users.email) LIKE ?
             OR lower(users.login) LIKE ?
             OR lower(dest_desc) LIKE ?
             OR lower(form_email) LIKE ?
             OR lower(form_user) LIKE ? ", qv, qv, qv, qv, qv]
        ).references(:users)
        travel_requests = array_join(operator, travel_requests, trs)

        gftrs = GrantFundedTravelRequest.includes(:user).where(user_id: allowable_ids)
          .where(
          ["lower(users.email) LIKE ?
             OR lower(users.login) LIKE ?
             OR lower(dest_desc) LIKE ?
             OR lower(form_email) LIKE ?
             OR lower(form_user) LIKE ? ", qv, qv, qv, qv, qv]
        ).references(:users)
        gf_travel_requests = array_join(operator, travel_requests, gftrs)
      end
      operator = 'and'
    end
    r = leave_requests.merge(travel_requests).merge(gf_travel_requests)
      .to_a.sort_by{ |r| r.send(sort_by) }
    return sort_order == "desc" ? r.reverse! : r
  end

  private

  def self.array_join(opp, arr1, arr2)
    if opp == 'and'
      return arr1 & arr2
    elsif opp == 'not'
      return arr1 - arr2
    end
    return arr1 | arr2
  end
end
