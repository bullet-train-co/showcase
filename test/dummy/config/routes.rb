Rails.application.routes.draw do
  get "/main_app_root" => redirect("/"), as: :main_app_root

  root to: redirect("/docs/showcase")

  mount Showcase::Engine, at: "docs/showcase"
end
