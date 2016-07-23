Rails.application.routes.draw do
  devise_for :employers
  resources :workers do
    resources :work_references
    member do
      get :confirm
      post :verify_confirmation
      get :resend_confirmation
      get :new_password
      patch :reset_password
    end
  end

  root 'workers#index'
  get 'signin' => 'sessions#new'
  get 'workers_signin' => 'workers_sessions#new'
  resource :workers_session
  resource :session
  get 'forgot_password' => 'workers#forgot_password'
  post 'forgot_password' => 'workers#send_reset_code'

  get 'signup_worker' => 'workers#new'
  get 'choose_role' => 'visitors#choose_role'
=begin
  resources :users do
    member do
    get :confirm
      post :verify_confirmation
    end
  end
=end
  get 'workers/filter/:scope' => 'workers#index', as: :filtered_workers
end
