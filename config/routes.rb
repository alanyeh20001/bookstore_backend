Rails.application.routes.draw do
  root to: "authors#index"

  namespace :api do
    namespace :v1 do
      resources :authors do
        resources :books
      end
      resource :auth, only: %i[create]
    end
  end
end
