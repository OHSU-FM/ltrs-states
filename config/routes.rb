Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  resources :home, only: :index
  root to: 'home#index'
  resources :users, only: [:show, :edit] do
    resources :forms, controller: 'users/forms', only: :index do
      member do
        put  'submit'
        post 'submit'
      end
    end
    match 'delegate_forms' => 'users/forms#delegate_forms', via: :get, as: :delegate_forms
  end
  resources :leave_requests do
    member do
      post 'submit' => 'leave_requests#submit'
      post 'send_to_unopened' => 'leave_requests#send_to_unopened'
      post 'review' => 'leave_requests#review'
      post 'reject' => 'leave_requests#reject'
      post 'accept' => 'leave_requests#accept'
    end
  end

  resources :travel_requests, except: :index
end
