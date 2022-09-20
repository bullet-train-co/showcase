Rails.application.routes.draw do
  namespace :viewtale do
    resources :pages, only: %i[ index show ]

    root to: "pages#index"
  end
end
