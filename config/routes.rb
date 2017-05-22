Rails.application.routes.draw do
  root to: 'leave_requests#index'
  resources :approval_states
  resources :leave_requests do
    member do
      post 'submit' => 'leave_requests#submit'
      post 'send_to_unopened' => 'leave_requests#send_to_unopened'
      post 'review' => 'leave_requests#review'
      post 'reject' => 'leave_requests#reject'
      post 'accept' => 'leave_requests#accept'
    end
  end
end
