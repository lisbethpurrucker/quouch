Rails.application.routes.draw do
  root to: "pages#home"

  resources :couches do
    resources :bookings, only: %i[new create] do
      resources :reviews, only: %i[new create]
    end
  end

  resources :bookings, only: %i[index show destroy] do
    member do
      get :sent
      patch :accept
      patch :decline
    end
  end

  resources :cities, only: %i[index show]

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
