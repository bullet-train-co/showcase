require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :root, :sample_renderer
  @root = "app/views/showcase/pages/templates"
  @sample_renderer = ->(lines) { lines.join }

  def self.filenames
    Dir.glob("**/*.*", base: root)
  end
end
