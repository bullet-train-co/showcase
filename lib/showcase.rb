require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/showcase-rails.rb")
loader.setup

module Showcase
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
end

require "showcase/engine" if defined?(Rails::Engine)
