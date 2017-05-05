User.create(first_name: 'test', last_name: 'user', email: 'test@test.org', login: 'test')
LeaveRequest.create(user: User.first)
