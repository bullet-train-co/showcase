Rails.application.routes.draw do
  root to: redirect("/docs/showcase")

  mount Showcase::Engine, at: "docs/showcase"
end
