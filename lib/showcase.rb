require_relative "showcase/version"

module Showcase
  autoload :IntegrationTest, "showcase/integration_test"
  autoload :RouteHelper,     "showcase/route_helper"
  autoload :Options,         "showcase/options"

  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = ->(lines) { tag.pre lines.join.strip_heredoc }

  singleton_class.attr_reader :previews_path
  @previews_path = "showcase/previews"

  def self.previews
    Showcase::EngineController.view_paths.map(&:path).flat_map do |root|
      Dir.glob("**/*.*", base: File.join(root, previews_path))
    end.uniq
  end

  def self.options
    Options
  end

  options.define :stimulus do
    def targets(name, ...)
      option(%(data-#{@controller}-target="#{name}"), ...)
    end

    def values(name, ...)
      option("data-#{@controller}-#{name}-value", ...)
    end

    def classes(name, ...)
      option("data-#{@controller}-#{name}-class", ...)
    end

    def outlet(name, ...)
      option("data-#{@controller}-#{name}-outlet", ...)
    end

    def action(name, ...)
      option(%(data-action="#{name}"), ...)
    end
  end

  options.define :nice_partials do
    def content_block(*arguments, **options, &block)
      option(*arguments, **options, type: "Content Block", &block)
    end
  end
end

require "showcase/engine" if defined?(Rails::Engine)
