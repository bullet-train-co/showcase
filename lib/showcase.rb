require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = ->(lines) { tag.pre lines.join.strip_heredoc }

  singleton_class.attr_reader :templates_path
  @templates_path = "showcase/pages/templates"

  def self.templates
    Showcase::EngineController.view_paths.map(&:path).flat_map do |root|
      Dir.glob("**/*.*", base: File.join(root, templates_path))
    end.uniq
  end

  def self.options
    Page::Options
  end
end
