u=User.create(first_name: 'test', last_name: 'user', email: 'test@test.org', login: 'test')
r=User.create(first_name: 'reviewer', last_name: 'user', email: 'reviewer@test.org', login: 'reviewer')
n=User.create(first_name: 'notifier', last_name: 'user', email: 'notifier@test.org', login: 'notifier')
UserApprover.create(user: u, approver_id: r.id, approver_type: 'reviewer', approval_order: 1)
UserApprover.create(user: u, approver_id: n.id, approver_type: 'notifier', approval_order: 2)
LeaveRequest.create(user: User.first)
