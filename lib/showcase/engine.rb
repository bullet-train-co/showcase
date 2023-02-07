module Showcase
  class Engine < ::Rails::Engine
    isolate_namespace Showcase

    initializer "showcase.assets" do |app|
      app.config.assets.precompile += %w[showcase_manifest]
    end

    initializer "showcase.with_options.backport" do
      if Rails.version < "7.0"
        require "active_support/core_ext/object/with_options"

        module WithOptionsBackport
          def with_options(options, &block)
            if block.nil?
              super(options) { break _1 }
            else
              super(options, &block)
            end
          end
        end

        Object.prepend WithOptionsBackport
      end
    end
  end
end
