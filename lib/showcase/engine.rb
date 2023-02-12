module Showcase
  class Engine < ::Rails::Engine
    isolate_namespace Showcase

    initializer "showcase.assets" do
      config.assets.precompile += %w[showcase_manifest]
    end

    initializer "showcase.integration_test.autorun" do
      Showcase::IntegrationTest.autorun if Rails.env.test?
    end

    server do
      Process.detach spawn("bin/tailwindcss", "--watch", chdir: "../..") if Rails.env.development?
    end
  end
end
