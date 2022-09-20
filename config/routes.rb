Rails.application.routes.draw do
  namespace :viewtale do
    resources :pages, only: %i[ index show ]
  end
end
