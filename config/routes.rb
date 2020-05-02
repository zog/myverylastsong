Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  match '/search', to: 'spotify#search', as: 'search_song', via: [:get]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'songs#index'
  resources :songs do
    collection do
      patch :update_sequence
    end

    member do
      get :itunes_link
    end
  end

  get '/:user_id', to: 'users#show'
  post '/users', to: 'users#upsert'

  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'
end
