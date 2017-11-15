Rails.application.routes.draw do
  root to: "authors#index"

  resources :authors do
    resources :books
  end
end
