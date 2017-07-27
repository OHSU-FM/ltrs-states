Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  resources :home, only: :index
  root to: 'home#index'
  resources :users, only: [:show, :edit, :update] do
    resources :forms, controller: 'users/forms', only: :index do
      member do
        put  'submit'
        post 'submit'
      end
    end
    resources :approvals, only: [:index], controller: 'users/approvals'
    match 'delegate_forms' => 'users/forms#delegate_forms', via: :get, as: :delegate_forms
  end
  resources :leave_requests, except: [:index, :edit, :update] do
    member do
      post 'submit' => 'leave_requests#submit'
      post 'send_to_unopened' => 'leave_requests#send_to_unopened'
      post 'review' => 'leave_requests#review'
      post 'reject' => 'leave_requests#reject'
      post 'accept' => 'leave_requests#accept'
      post 'update_state' => 'leave_requests#update_state'
    end
  end

  resources :travel_requests, except: [:index, :edit, :update] do
    member do
      post 'submit' => 'travel_requests#submit'
      post 'send_to_unopened' => 'travel_requests#send_to_unopened'
      post 'review' => 'travel_requests#review'
      post 'reject' => 'travel_requests#reject'
      post 'accept' => 'travel_requests#accept'
      post 'update_state' => 'travel_requests#update_state'
    end
  end

  resources :grant_funded_travel_requests, except: [:index, :edit, :update] do
    member do
      post 'submit' => 'grant_funded_travel_requests#submit'
      post 'send_to_unopened' => 'grant_funded_travel_requests#send_to_unopened'
      post 'review' => 'grant_funded_travel_requests#review'
      post 'reject' => 'grant_funded_travel_requests#reject'
      post 'accept' => 'grant_funded_travel_requests#accept'
      post 'update_state' => 'grant_funded_travel_requests#update_state'
    end
  end

  match :ldap_search, to: 'users#ldap_search', via: :get, as: :ldap_search
end
