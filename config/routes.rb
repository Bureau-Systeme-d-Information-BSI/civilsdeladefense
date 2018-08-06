Rails.application.routes.draw do
  devise_for :users, timeout_in: 30.minutes
end
