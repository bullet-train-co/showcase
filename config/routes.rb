Showcase::Engine.routes.draw do
  get "previews/*id", to: "previews#show", as: :preview
  root to: "previews#index"
end
