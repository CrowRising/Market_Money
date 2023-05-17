# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: %i[index show] do
        resources :vendors, only: [:index]
      end
      resources :vendors, only: %i[show create update destroy]
      resources :market_vendors, only: [:create]
    end
  end
end
