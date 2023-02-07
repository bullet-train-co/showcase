module Showcase
  class Engine < ::Rails::Engine
    isolate_namespace Showcase

    initializer "showcase.assets" do |app|
      app.config.assets.precompile += %w[showcase_manifest]
    end
  end
end
