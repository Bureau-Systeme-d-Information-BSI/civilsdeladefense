Rails.application.routes.draw do

  as :administrator do
    patch '/admin/confirmation' => 'administrators/confirmations#update', as: :update_administrator_confirmation
  end
  devise_for :administrators, path: 'admin', controllers: { confirmations: 'administrators/confirmations' }, timeout_in: 30.minutes
  devise_for :users

  namespace :admin do
    resource :account do
      member do
        get :change_email, :change_password
        patch :update_email, :update_password
      end
    end
    resources :salary_ranges, only: %i(index)
    resources :job_offers, path: 'offresdemploi' do
      collection do
        get :archived
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
        post :check_file
        post :uncheck_file
      end
      resources :messages, only: %i(create)
      resources :emails, only: %i(create) do
        member do
          post :mark_as_read
          post :mark_as_unread
        end
      end
    end
    namespace :settings, path: 'parametres' do
      resources :administrators, path: 'administrateurs', except: %i(destroy) do
        collection do
          get :inactive
        end
        member do
          post :resend_confirmation_instructions
          post :deactivate
        end
      end
      resources :employers
      resources :email_templates
      resources :salary_ranges
      JobOffer::SETTINGS.each do |setting|
        resources setting.to_s.pluralize.to_sym, except: %i(show)
      end
      root to: 'administrators#index'
    end
    root to: 'job_offers#index'
  end

  scope as: 'account', module: 'account' do
    resources :job_applications, path: 'mes-candidatures' do
      collection do
        get :finished
      end
      resources :emails, only: %i(index create)
    end
    resource :user, path: 'mon-compte', only: %i(show update destroy) do
      member do
        get :change_email, :change_password
        patch :update_email, :update_password
      end
    end
  end

  resources :job_offers, path: 'offresdemploi', only: %i(index show) do
    member do
      get :apply
      post :send_application
      get :successful
    end
  end

  resource :robots, only: %w(show)
  resource :sitemap

  root to: 'job_offers#index'
end
