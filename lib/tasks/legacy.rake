# migrate old fmdept_apps records into ltrs-states classes
namespace :legacy_migrate do
  desc 'migrate old Users to new Users'
  task user: :environment do
    successes = 0
    fails = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"
    ActiveRecord::Base.record_timestamps = false

    LegacyUser.all.each do |record|
      begin
        if User.with_deleted.find_by_email(record.email).present?
          puts "User #{record.id} already migrated"
          successes += 1
          next
        end
        name = record.name.split(" ")
        first_name = name[0]
        last_name = name[1..-1].join(" ")
        last_name = "test" if last_name.empty?
        new_record = User.new
        new_record.attributes = {
          email: record.email,
          login: record.login,
          first_name: first_name,
          last_name: last_name,
          encrypted_password: record.encrypted_password,
          is_admin: record.is_admin,
          timezone: record.timezone,
          empid: record.empid,
          emp_class: record.emp_class,
          emp_home: record.emp_home,
          is_ldap: record.is_ldap,
          grant_funded: false,
          created_at: record.created_at,
          updated_at: record.updated_at
        }
        new_record.save!
        if record.deleted_at?
          new_record.update(deleted_at: record.deleted_at)
        end
        successes += 1
        puts "User #{record.id} successfully migrated"
      rescue
        puts "Error migrating User #{record.id}"
        fails += 1
      end
    end

    puts "#{successes} users successfully migrated, #{fails} failures"
    ActiveRecord::Base.record_timestamps = false
  end

  desc "migrate old UserDefaultEmails to new UserApprovers (assumes Users have already been migrated)"
  task user_approver: :environment do
    successes = 0
    fails = 0
    skipped = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"
    ActiveRecord::Base.record_timestamps = false

    LegacyUserApprover.all.each do |record|
      begin
        if User.find_by_email(record.email).nil? && User.with_deleted.find_by_email(record.email).present?
          puts "the user for this record (#{record.id}) has been deleted"
          skipped += 1
          next
        end
        if UserApprover.where(
            user_id: User.find_by_email(record.legacy_user.email.downcase).id,
            approver_id: User.find_by_email(record.email.downcase).id).present?
          puts "UserDefaultEmail #{record.id} already migrated"
          successes += 1
          next
        end
        new_record = UserApprover.new
        new_record.attributes = {
          user_id: User.find_by_email(record.legacy_user.email.downcase).id,
          approver_id: User.find_by_email(record.email.downcase).id,
          approver_type: LegacyUserApprover::ROLE_ID_CODES[record.role_id],
          approval_order: record.approval_order,
          created_at: record.created_at,
          updated_at: record.updated_at
        }
        new_record.save!
        puts "UserDefaultEmail #{record.id} successfully migrated"
        successes += 1
      rescue
        puts "Error migrating UserDefaultEmail #{record.id}"
        fails += 1
      end
    end

    ActiveRecord::Base.record_timestamps = true
    puts "#{successes} UDEs successfully migrated, #{fails} failures, #{skipped} skipped"
  end

  desc "migrate old LeaveRequests to new LeaveRequests (assumes Users have already been migrated)"
  task leave_request: :environment do
    successes = 0
    fails = 0
    skipped = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"

    LegacyLeaveRequest.all.each do |record|
      begin
        if record.legacy_approval_state.nil?
          puts "LeaveRequest #{record.id} doesn't have an approval state? skipping"
          skipped += 1
          next
        end
        if LeaveRequest.where(
            user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
            start_date: record.start_date,
            end_date: record.end_date,
            desc: record.desc,
            has_extra: record.has_extra
          ).present?
          puts "LeaveRequest #{record.id} already migrated"
          successes += 1
          next
        end

        new_record = LeaveRequest.new
        new_record.attributes = {
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          form_user: record.form_user,
          form_email: record.form_email,
          start_date: record.start_date,
          start_hour: record.start_hour,
          start_min: record.start_min,
          end_date: record.end_date,
          end_hour: record.end_hour,
          end_min: record.end_min,
          desc: record.desc,
          hours_vacation: record.hours_vacation,
          hours_sick: record.hours_sick,
          hours_other: record.hours_other,
          hours_other_desc: record.hours_other_desc,
          hours_training: record.hours_training,
          hours_training_desc: record.hours_training_desc,
          hours_comp: record.hours_comp,
          hours_comp_desc: record.hours_comp_desc,
          hours_cme: record.hours_cme,
          has_extra: record.has_extra,
          need_travel: record.need_travel,
          created_at: record.created_at,
          updated_at: record.updated_at
        }
        if record.deleted_at?
          new_record.update(deleted_at: record.deleted_at)
        end

        new_record.save!

        approval_state_attributes = {
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          aasm_state: LegacyApprovalState::STATES[record.legacy_approval_state.status],
          approval_order: record.legacy_approval_state.approval_order,
          created_at: record.legacy_approval_state.created_at,
          updated_at: record.legacy_approval_state.updated_at
        }
        new_record.approval_state.update!(approval_state_attributes)


        puts "LeaveRequest #{record.id} successfully migrated"
        successes += 1
      rescue
        puts "Error migrating LeaveRequest #{record.id}"
        fails += 1
      end
    end

    puts "#{successes} LeaveRequests successfully migrated, #{fails} failures, #{skipped} skipped"
  end

  desc "migrate old LeaveRequestExtras to new LeaveRequestExtrass (assumes Users and LeaveRequests have already been migrated)"
  task leave_request_extra: :environment do
    successes = 0
    fails = 0
    skipped = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"
    ActiveRecord::Base.record_timestamps = false

    LegacyLeaveRequest.select{|llr| !llr.legacy_leave_request_extra.nil?}.each do |record|
      begin
        lr = LeaveRequest.where(
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          start_date: record.start_date,
          end_date: record.end_date,
          desc: record.desc,
          has_extra: record.has_extra
        ).first

        next if lr.nil?

        llre = record.legacy_leave_request_extra

        if lr.leave_request_extra.present?
          puts "LeaveRequestExtra #{llre.id} already migrated"
          successes += 1
          next
        end

        new_record = LeaveRequestExtra.new
        new_record.attributes = {
          leave_request_id: lr.id,
          work_days: llre.work_days,
          work_hours: llre.work_hours,
          basket_coverage: llre.basket_coverage,
          covering: llre.covering,
          hours_professional: llre.hours_professional,
          hours_professional_desc: llre.hours_professional_desc,
          hours_professional_role: llre.hours_professional_role,
          hours_administrative: llre.hours_administrative,
          hours_administrative_desc: llre.hours_administrative_desc,
          hours_administrative_role: llre.hours_administrative_role,
          funding_no_cost: llre.funding_no_cost,
          funding_no_cost_desc: llre.funding_no_cost_desc,
          funding_approx_cost: llre.funding_approx_cost,
          funding_split: llre.funding_split,
          funding_split_desc: llre.funding_split_desc,
          funding_grant: llre.funding_grant,
          created_at: llre.created_at,
          updated_at: llre.updated_at
        }

        if record.deleted_at?
          new_record.update(deleted_at: record.deleted_at)
        end

        new_record.save!

        puts "LeaveRequestExtra #{llre.id} successfully migrated"
        successes += 1
      rescue
        puts "Error migrating LeaveRequestExtra #{llre.id}"
        byebug
        fails += 1
      end
    end
    puts "#{successes} LeaveRequestExtras successfully migrated, #{fails} failures, #{skipped} skipped"
  end

  desc 'migrate old TravelRequests to new TravelRequests (assumes users have already been migrated)'
  task travel_request: :environment do
    successes = 0
    fails = 0
    skipped = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"

    LegacyTravelRequest.all.each do |record|
      begin
        if record.legacy_approval_state.nil?
          puts "TravelRequest #{record.id} doesn't have an approval state? skipping"
          skipped += 1
          next
        end

        if TravelRequest.where(
            user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
            dest_depart_date: record.dest_depart_date,
            ret_depart_date: record.ret_depart_date,
            dest_desc: record.dest_desc,
          ).present?
          puts "TravelRequest #{record.id} already migrated"
          successes += 1
          next
        end

        new_record = TravelRequest.new
        new_record.attributes = record.attributes.except("id")
          .update(user_id: User.with_deleted.find_by_email(record.legacy_user.email).id)

        if record.deleted_at?
          new_record.update(deleted_at: record.deleted_at)
        end

        new_record.save!

        approval_state_attributes = {
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          aasm_state: LegacyApprovalState::STATES[record.legacy_approval_state.status],
          approval_order: record.legacy_approval_state.approval_order,
          created_at: record.legacy_approval_state.created_at,
          updated_at: record.legacy_approval_state.updated_at
        }
        new_record.approval_state.update!(approval_state_attributes)

        puts "TravelRequest #{record.id} successfully migrated"
        successes += 1
      rescue => error
        puts "Error migrating TravelRequest #{record.id}"
        byebug
        fails += 1
      end
    end

    puts "#{successes} TravelRequests successfully migrated, #{fails} failures, #{skipped} skipped"
  end

  desc 'migrate old UserDelegations to new UserDelegations (assumes users have already been migrated)'
  task user_delegation: :environment do
    successes = 0
    fails = 0
    skips = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"
    ActiveRecord::Base.record_timestamps = false

    LegacyUserDelegation.all.each do |record|
      begin
        if UserDelegation.where(
            user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
            delegate_user_id: User.with_deleted.find_by_email(record.legacy_delegate.email).id,
          ).present?
          puts "UserDelegation #{record.id} already migrated"
          successes += 1
          next
        end

        new_record = UserDelegation.new
        new_record.attributes = {
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          delegate_user_id: User.with_deleted.find_by_email(record.legacy_delegate.email).id,
          created_at: record.created_at,
          updated_at: record.updated_at
        }

        new_record.save!

        successes += 1
        puts "UserDelegation #{record.id} successfully migrated"
      rescue => error
        puts "Error migrating UserDelegation #{record.id}"
        byebug
        fails += 1
      end
    end

    puts "#{successes} user delegations successfully migrated, #{fails} failures, #{skips} skipped"
    ActiveRecord::Base.record_timestamps = false
  end

  desc 'migrate old UserFiles to new UserFiles (assumes users have already been migrated)'
  task user_file: :environment do
    successes = 0
    fails = 0
    skips = 0
    require "#{Rails.root}/lib/tasks/legacy_classes"
    ActiveRecord::Base.record_timestamps = false

    LegacyUserFile.all.each do |record|
      begin
        next if record.legacy_user.nil?

        new_record = UserFile.new
        new_record.attributes = {
          user_id: User.with_deleted.find_by_email(record.legacy_user.email).id,
          uploaded_file_name: record.uploaded_file_file_name,
          uploaded_file_content_type: record.uploaded_file_content_type,
          uploaded_file_file_size: record.uploaded_file_file_size,
          uploaded_file_updated_at: record.uploaded_file_updated_at,
          created_at: record.created_at,
          updated_at: record.updated_at
        }

        new_record.save!

        successes += 1
        puts "UserFile #{record.id} successfully migrated"
      rescue => error
        puts "Error migrating UserFile #{record.id}"
        byebug
        fails += 1
      end
    end

    puts "#{successes} user files successfully migrated, #{fails} failures, #{skips} skipped"
    ActiveRecord::Base.record_timestamps = false
  end
end
