Rails.application.routes.draw do
  devise_for :users
  
  resources :lessons do
    resources :enrollments, only: [:create]
  end
  resources :enrollments, only: [:destroy]

  namespace :api do
    resources :lessons, only: [:index]
    resources :enrollments, only: [:create, :destroy]
  end

  root "lessons#index"
end