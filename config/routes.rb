Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#index'

  resources :pulsecheckers
  get 'profile', action: :show, controller: 'profile'
  put 'profile_update', action: :update, controller: 'profile'
  put 'update_password', action: :update_password, controller: 'profile'
end
