Rails.application.routes.draw do
  root to: "pages#home"

  resources :couches do
    resources :bookings, only: %i[new create] do
      collection do
        get :requests
      end

      resources :reviews, only: %i[new create]
    end
  end

  resources :bookings, only: %i[index show destroy edit update] do
    member do
      get :show_request, as: 'request'
      get :sent
      patch :accept
      patch :decline
      patch :cancel
    end
  end

  resources :cities, only: %i[index show]
  
  # resources :chat, only: :show
  # resources :messages, only: %i[index show create]

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
