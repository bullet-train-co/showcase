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
          extend ActiveSupport::Concern

          included do
            alias_method :__original_with_options, :with_options

            def with_options(options, &block)
              if block.nil?
                options_merger = nil
                __original_with_options(options) { |object| options_merger = object }
                options_merger
              else
                __original_with_options(options, &block)
              end
            end
          end
        end

        Object.include WithOptionsBackport
      end
    end
  end
end
