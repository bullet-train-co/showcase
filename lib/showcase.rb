require_relative "showcase/version"

module Showcase
  autoload :IntegrationTest, "showcase/integration_test"
  autoload :RouteHelper,     "showcase/route_helper"

  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = ->(lines) { tag.pre lines.join.strip_heredoc }

  singleton_class.attr_reader :previews_path
  @previews_path = "showcase/previews"

  def self.previews
    Showcase::EngineController.view_paths.map(&:path).flat_map do |root|
      Dir.glob("**/*.*", base: File.join(root, previews_path))
    end.uniq
  end
end

require "showcase/engine" if defined?(Rails::Engine)
