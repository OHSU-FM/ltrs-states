Rails.application.routes.draw do
  root to: 'leave_requests#index'
  resources :approval_states
  resources :leave_requests do
    member do
      post 'submit' => 'leave_requests#submit'
    end
  end
end
