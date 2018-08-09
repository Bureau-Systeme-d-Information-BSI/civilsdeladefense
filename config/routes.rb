Rails.application.routes.draw do
  devise_for :admins, timeout_in: 30.minutes
  devise_for :users

  namespace :admin do
    resources :job_offers
    root to: 'job_offers#index'
  end

  resources :job_offers, only: %i(index show) do
    member do
      get :apply
    end
  end

  root to: 'job_offers#index'
end
