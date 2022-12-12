require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :templates_directory_prefix, :sample_renderer
  @templates_directory_prefix = ""
  @sample_renderer = ->(lines) { lines.join }

  def self.templates_path
    File.join(templates_directory_prefix, "showcase/pages/templates").delete_prefix("/")
  end

  def self.filenames
    Dir.glob("**/*.*", base: File.join("app/views", templates_path))
  end
end
