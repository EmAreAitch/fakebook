Rails.application.routes.draw do
  defaults export: true do
    devise_for :users,
               controllers: {
                 registrations: "users/registrations",
                 sessions: "users/sessions"
               }
    resources :posts do
      member do
        post "like", to: "posts#like" # POST request to /posts/:id/like
        delete "like", to: "posts#unlike" # DELETE request to /posts/:id/like
      end
      resources :comments, except: %i[edit update destroy show] do
        resources :comments,
                  except: %i[edit update destroy show],
                  as: :replies,
                  path: :replies
      end
    end

    resources :profiles, param: :username do
      get :follow_status, on: :member
      resources :follows, only: [:index]
    end

    resources :chats, param: :username, only: [:show]
    resources :chats, except: [:show]

    resources :follows, except: %i[update index show] do
      patch :accept, on: :member
    end
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    root "posts#index"
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    namespace :webauthn do
      resources :credentials, only: %i[index create destroy] do
        collection do
          resource :challenge,
                   only: %i[create],
                   module: :credentials,
                   as: :credentials_challenge
        end
      end

      resources :authentications, only: %i[index create], path: :auth do
        collection do
          resource :challenge,
                   only: %i[create],
                   module: :authentications,
                   as: :authentications_challenge
        end
      end
    end
  end
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
