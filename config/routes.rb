# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/password/change', to: 'users/registrations#edit_password', as: :edit_user_registration_password
    put 'users/password/change', to: 'users/registrations#update_password', as: :update_user_registration_password
  end

  # Defines the root path route ("/")
  root 'home#index'

  # Frontend section
  get 'dashboard', to: 'users/dashboard#index', as: :user_root
end
