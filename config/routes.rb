Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#index'

  resources :pulsecheckers, except: %i[show edit new] do
    put :change_status
  end

  get 'profile', action: :show, controller: 'profile'
  put 'update_profile', action: :update, controller: 'profile'
  put 'update_password', action: :update_password, controller: 'profile'

  get '/*slug', controller: :pulsecheckers, action: :show
end
