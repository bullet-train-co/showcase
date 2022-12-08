Showcase::Engine.routes.draw do
  get "*id", to: "displays#show", as: :display
  root to: "displays#index"
end
