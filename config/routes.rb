Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "itineraries#index" 
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  #omni stuff
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: "sessions#failure"

  # search / filter
  resources :itineraries, only: [:index]

  # itinerary actions
  resources :itinerary_groups,
            path: "itineraries",   
            as:   "itinerary" do
              # only: [:show, :edit, :update] do
    member do
      get  "join"
      post "join", action: "join_itinerary"
    end
  end

  # view accounts 
  resources :accounts, only: [:index, :update, :destroy]


  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # Routes used by group chat Cucumber scenarios:
  # visit("/itinerary_groups/:id/messages")
  get  "/itineraries/:id/messages", to: "messages#index",  as: :itinerary_group_messages
  post "/itineraries/:id/messages", to: "messages#create", as: :create_itinerary_group_message
  patch "/messages/:id",                 to: "messages#update", as: :message

  # flights & hotels
  resources :flights, only: [:index] # no individual show
  resources :hotels, only: [:index] # no individual show

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: [:new, :create, :edit, :update]

end
