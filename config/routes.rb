Showcase::Engine.routes.draw do
  get "pages(/:engine_id)/*id", to: "pages#show", as: :page
  root to: "pages#index"
end
