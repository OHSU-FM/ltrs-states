Rails.application.routes.draw do
  resources :travel_requests
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
  resources :leave_requests, except: :index do
    member do
      post 'submit' => 'leave_requests#submit'
      post 'send_to_unopened' => 'leave_requests#send_to_unopened'
      post 'review' => 'leave_requests#review'
      post 'reject' => 'leave_requests#reject'
      post 'accept' => 'leave_requests#accept'
      post 'update_state' => 'leave_requests#update_state'
    end
  end

  resources :travel_requests, except: :index

  match :ldap_search, to: 'users#ldap_search', via: :get, as: :ldap_search
end
