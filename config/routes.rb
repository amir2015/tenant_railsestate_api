Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                skip: :all,
                defaults: { format: :json }

      devise_scope :user do
        post '/auth/login', to: 'sessions#create'
        delete '/auth/logout', to: 'sessions#destroy'
        post '/auth/register', to: 'registrations#create'
        post '/auth/password', to: 'passwords#create'
        put '/auth/password', to: 'passwords#update'
      end

      post '/auth/register_company', to: 'companies#register'
    end
  end

  constraints subdomain: /^(?!www$)[a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?$/i do
    namespace :api do
      namespace :v1 do
        get '/companies/current', to: 'companies#show'
        patch '/companies/current', to: 'companies#update'
        resources :properties do
        collection do
          get :search
        end
        member do
          post :images, to: 'properties#add_images'
        end
        end
      end
    end
  end
end
