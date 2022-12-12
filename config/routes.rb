Showcase::Engine.routes.draw do
  get "*id", to: "pages#show", as: :page
  root to: "pages#index"
end
