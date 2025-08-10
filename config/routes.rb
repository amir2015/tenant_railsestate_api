Rails.application.routes.draw do
 post "/api/v1/auth/register_company", to: "api/v1/companies#register"
  constraints subdomain: /^(?!www$)[a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?$/i do
    namespace :api do
      namespace :v1 do
        devise_scope :user do
          post "/auth/login", to: "sessions#create"
          delete "/auth/logout", to: "sessions#destroy"
        end
        get '/companies/current', to: 'companies#show'
        patch '/companies/current', to: 'companies#update'
      end
    end
  end
end
