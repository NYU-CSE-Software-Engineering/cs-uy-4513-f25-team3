Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # search / filyer
  resources :itineraries, only: [:index]

  # restful route for viewing itinerary groups
  resources :itinerary_groups, only: [:show]

  # itinerary actions
  resources :itinerary_groups,
            path: "itineraries",
            as:   "itinerary",
            only: [:edit, :update] do
    member do
      get  "join"
      post "join", action: "join_itinerary"
    end
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  get '/itineraries', to: 'itineraries#index'

end