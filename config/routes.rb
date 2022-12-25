Rails.application.routes.draw do
 root 'cams#index'

 resources :shodan_api_keys
 
  get 'cams', to: 'cams#index', as: 'cams'
  get 'cams/favorites', to: 'cams#favorites', as: 'favorite_cams'
  post 'cams/:id/favorite', to: 'cams#add_favorite', as: 'add_favorite_cam'
  get 'cams/:id', to: 'cams#show', as: 'show_cam'

  get 'pwn_job/start', to: 'pwn_jobs#start', as: 'pwn_job_start'
end
