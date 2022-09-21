Rails.application.routes.draw do
  namespace :showcase do
    get "displays/*id", to: "displays#show", as: :display

    root to: "displays#index"
  end
end
