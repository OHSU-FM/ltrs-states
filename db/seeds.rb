# u=User.create(first_name: 'test', last_name: 'user', email: 'test@test.org', login: 'test', password: "password", is_ldap: false)
# r=User.create(first_name: 'reviewer', last_name: 'user', email: 'reviewer@test.org', login: 'reviewer', password: "password", is_ldap: false)
# u2=User.create(first_name: 'testmult', last_name: 'user', email: 'testmult@test.org', login: 'testmult', password: "password", is_ldap: false)
# r2=User.create(first_name: 'reviewer2', last_name: 'user', email: 'reviewer2@test.org', login: 'reviewer2', password: "password", is_ldap: false)
# n=User.create(first_name: 'notifier', last_name: 'user', email: 'notifier@test.org', login: 'notifier', password: "password", is_ldap: false)
#
# UserApprover.create(user: u, approver_id: r.id, approver_type: 'reviewer', approval_order: 1)
# UserApprover.create(user: u, approver_id: n.id, approver_type: 'notifier', approval_order: 2)
# UserApprover.create(user: u2, approver_id: r.id, approver_type: 'reviewer', approval_order: 1)
# UserApprover.create(user: u2, approver_id: r2.id, approver_type: 'reviewer', approval_order: 2)
# UserApprover.create(user: u2, approver_id: n.id, approver_type: 'notifier', approval_order: 3)
# LeaveRequest.create(user: User.first)
#
# User.create(first_name: 'admin', last_name: 'user', email: 'admin@test.org', login: 'admin', password: "password", is_ldap: false, is_admin: true)
#
# g=User.create(first_name: 'grant_funded', last_name: 'user', email: 'grant@test.org', login: 'grant', password: "password", is_ldap: false, grant_funded: true)
# UserApprover.create(user: g, approver_id: r.id, approver_type: 'reviewer', approval_order: 1)
# UserApprover.create(user: g, approver_id: n.id, approver_type: 'notifier', approval_order: 2)
