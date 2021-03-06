Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  resources :home, only: :index
  root to: 'home#index'
  resources :users, only: [:show, :edit, :update] do
    get 'travel_profile'
    resources :forms, controller: 'users/forms', only: :index do
      member do
        put  'submit'
        post 'submit'
      end
    end
    resources :approvals, only: [:index], controller: 'users/approvals'
    match 'delegate_forms' => 'users/forms#delegate_forms', via: :get, as: :delegate_forms
  end

  get '/leave_requests', to: redirect('/')
  resources :leave_requests, except: [:edit, :update] do
    member do
      post 'submit' => 'leave_requests#submit'
      post 'review' => 'leave_requests#review'
      post 'reject' => 'leave_requests#reject'
      post 'accept' => 'leave_requests#accept'
      post 'update_state' => 'leave_requests#update_state'
    end
  end

  get '/travel_requests', to: redirect('/')
  resources :travel_requests, except: [:edit, :update] do
    member do
      post 'submit' => 'travel_requests#submit'
      post 'review' => 'travel_requests#review'
      post 'reject' => 'travel_requests#reject'
      post 'accept' => 'travel_requests#accept'
      post 'update_state' => 'travel_requests#update_state'
    end
  end

  get '/grant_funded_travel_requests', to: redirect('/')
  resources :grant_funded_travel_requests do
    member do
      post 'submit' => 'grant_funded_travel_requests#submit'
      post 'review' => 'grant_funded_travel_requests#review'
      post 'reject' => 'grant_funded_travel_requests#reject'
      post 'accept' => 'grant_funded_travel_requests#accept'
      post 'update_state' => 'grant_funded_travel_requests#update_state'
    end
  end

  get '/reimbursement_requests', to: redirect('/')
  resources :reimbursement_requests do
    member do
      post 'submit' => 'reimbursement_requests#submit'
      post 'review' => 'reimbursement_requests#review'
      post 'reject' => 'reimbursement_requests#reject'
      post 'accept' => 'reimbursement_requests#accept'
      post 'update_state' => 'reimbursement_requests#update_state'
    end
  end

  resources :user_files
  match :ldap_search, to: 'users#ldap_search', via: :get, as: :ldap_search
end
