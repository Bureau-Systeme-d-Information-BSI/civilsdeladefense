Rails.application.routes.draw do

  as :administrator do
    patch '/administrators/confirmation' => 'administrators/confirmations#update', as: :update_administrator_confirmation
  end
  devise_for :administrators, controllers: { confirmations: 'administrators/confirmations' }, timeout_in: 30.minutes
  devise_for :users

  namespace :admin do
    resources :job_offers, path: 'offresdemploi'
    resources :job_applications, path: 'candidatures'
    namespace :settings, path: 'parametres' do
      resources :administrators, path: 'administrateurs' do
        member do
          post :resend_confirmation_instructions
        end
      end
      root to: 'base#index'
    end
    root to: 'job_offers#index'
  end

  resources :job_offers, path: 'offresdemploi', only: %i(index show) do
    member do
      get :apply
      post :send_application
      get :successful
    end
  end

  root to: 'job_offers#index'
end
