# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get 'users/password/change', to: 'users/registrations#edit_password', as: :edit_user_registration_password
    put 'users/password/change', to: 'users/registrations#update_password', as: :update_user_registration_password
  end

  # Defines the root path route ("/")
  root 'home#index'

  # Frontend section
  get 'dashboard', to: 'users/dashboard#index', as: :user_root

  namespace :users do
    resources :api_keys, only: %i[index create destroy]
  end

  # Backend section
  authenticate :user, ->(u) { u.admin? } do
    namespace :admin do
      mount Sidekiq::Web => '/sidekiq'
      root 'dashboard#index'
      resources :users do
        member do
          delete 'revoke_api_key/:api_key_id', to: 'users#revoke_api_key', as: :revoke_api_key
        end
      end
      resources :roles, only: %i[index]
      resources :tiers, only: %i[index]
    end
  end
end
