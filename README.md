# LTRS States

A state-machine-based request and approval app for OHSU FM

### Getting Started

```ruby
git clone git@github.com:OHSU-FM/ltrs-states.git && cd ltrs-states
bundle
rails db:create && rails db:migrate
rails s
```

There's a simplistic set of relationships in `seeds.rb`, so seed if you'd like, or just go grab the production database (easier for debugging).

Users are shown the grant funded travel and reimbursement request forms if the boolean `grant_funded` is true on their user record.

### Setting up a user

Users need (at least) a reviewer and a notifier. These are set up via `UserApprovers`. The `approval_order` of the notifier `UserApprover` is just 1 plus the `approval_order` of the last reviewer

### Specs

RSpec for testing, Guard to watch `/spec`. The main approval logic lives in `/app/controllers/concerns/state_events.rb`, and is tested primarily in the LeaveRequest controller spec.
