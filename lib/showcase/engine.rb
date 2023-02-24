module Showcase
  class Engine < ::Rails::Engine
    isolate_namespace Showcase

    initializer "showcase.assets" do
      config.assets.precompile += %w[showcase_manifest]
    end

    initializer "showcase.previews_test.autorun" do
      Showcase::PreviewsTest.autorun if Rails.env.test?
    end
  end
end
