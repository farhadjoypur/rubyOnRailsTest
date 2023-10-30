Rails.application.routes.draw do
  resources :users, only: [:new] do
    collection { post :import }
  end


  root 'users#new'
  get 'users', to: 'users#index'
end
