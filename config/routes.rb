Rails.application.routes.draw do
  root 'cams#index'

  resources :shodan_api_keys
  resources :search_n_probe_jobs, only: [ :new, :create ]


  get 'cams', to: 'cams#index', as: 'cams'
  get 'cams/favorites', to: 'cams#favorites', as: 'favorite_cams'
  post 'cams/:id/favorite', to: 'cams#add_favorite', as: 'add_favorite_cam'
  get 'cams/:id', to: 'cams#show', as: 'show_cam'

  resources :cams, only: [ :index, :show ]

  resource :favorite_cams, only: [ :update ]
  

end
