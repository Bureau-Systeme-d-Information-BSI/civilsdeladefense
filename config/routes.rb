Rails.application.routes.draw do

  as :administrator do
    patch '/administrators/confirmation' => 'administrators/confirmations#update', as: :update_administrator_confirmation
  end
  devise_for :administrators, controllers: { confirmations: 'administrators/confirmations' }, timeout_in: 30.minutes
  devise_for :users

  namespace :admin do
    resources :job_offers
    namespace :settings do
      resources :administrators do
        member do
          post :resend_confirmation_instructions
        end
      end
      root to: 'base#index'
    end
    root to: 'job_offers#index'
  end

  resources :job_offers, only: %i(index show) do
    member do
      get :apply
    end
  end

  root to: 'job_offers#index'
end
