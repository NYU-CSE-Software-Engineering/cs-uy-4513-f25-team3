Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google_oauth2[:client_id],
           Rails.application.credentials.google_oauth2[:client_secret],
           scope: 'email,profile'
end


OmniAuth.config.allowed_request_methods = [:get, :post]
