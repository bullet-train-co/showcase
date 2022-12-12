require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :root, :sample_renderer
  @root = "showcase/pages/templates"
  @sample_renderer = ->(lines) { lines.join }

  def self.template_path_to(id)
    File.join(root, id)
  end

  def self.filenames
    Dir.glob("**/*.*", base: File.join("app/views", root))
  end
end
