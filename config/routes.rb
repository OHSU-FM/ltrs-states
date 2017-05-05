Rails.application.routes.draw do
  root to: 'leave_requests#index'
  resources :approval_states
  resources :leave_requests do
    member do
      post 'submit'
    end
  end
end
