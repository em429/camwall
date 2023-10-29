Rails.application.routes.draw do
  root 'cams#index'

  resources :shodan_api_keys
  resources :search_n_probe_jobs, only: [ :index, :new, :create ]

  resources :cams, only: [ :index, :show ]
  post 'cams/:id/favorite', to: 'cams#toggle_favorite', as: 'toggle_favorite_cam'
  get 'favorite_cams', to: 'cams#favorites'
  
end
