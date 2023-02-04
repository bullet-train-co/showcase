require "showcase/version"
require "showcase/engine"

module Showcase
  autoload :IntegrationTest, "showcase/integration_test"

  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = ->(lines) { tag.pre lines.join.strip_heredoc }

  singleton_class.attr_reader :templates_path
  @templates_path = "showcase/samples"

  def self.templates
    Showcase::EngineController.view_paths.map(&:path).flat_map do |root|
      Dir.glob("**/*.*", base: File.join(root, templates_path))
    end.uniq
  end
end
