Rails.application.routes.draw do

  as :administrator do
    patch '/administrators/confirmation' => 'administrators/confirmations#update', as: :update_administrator_confirmation
  end
  devise_for :administrators, controllers: { confirmations: 'administrators/confirmations' }, timeout_in: 30.minutes
  devise_for :users

  namespace :admin do
    resources :job_offers, path: 'offresdemploi' do
      collection do
        JobOffer.aasm.events.map(&:name).each do |event_name|
          post("create_and_#{ event_name }".to_sym)
        end
      end
      member do
        JobOffer.aasm.events.map(&:name).each do |event_name|
          patch(event_name.to_sym)
          patch("update_and_#{ event_name }".to_sym)
        end
      end
    end
    resources :job_applications, path: 'candidatures' do
      member do
        patch :change_state
      end
      resources :messages, only: %i(create)
    end
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
