Showcase::Engine.routes.draw do
  get "pages/*id", to: "pages#show", as: :page
  root to: "pages#index"
end
