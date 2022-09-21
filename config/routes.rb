Rails.application.routes.draw do
  namespace :showcase do
    get "pages/*id", to: "pages#show", as: :page

    root to: "pages#index"
  end
end
