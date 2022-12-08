require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = ->(lines) { lines.join }
end
