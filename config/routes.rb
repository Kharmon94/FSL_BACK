Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get "up" => "health#show"
      post "auth/sign_in", to: "auth#sign_in"
      post "auth/sign_up", to: "auth#sign_up"
      get "auth/me", to: "auth#me"
      get "auth/:provider/callback", to: "auth#omniauth_callback"

      namespace :admin do
        # Admin-only resources
      end
    end
  end
end
