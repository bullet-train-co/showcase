require "showcase/version"
require "showcase/engine"

module Showcase
  singleton_class.attr_accessor :templates_directory_prefix, :sample_renderer
  @templates_directory_prefix = ""
  @sample_renderer = ->(lines) { lines.join }

  def self.templates_path
    @templates_path ||= File.join(templates_directory_prefix, "showcase/pages/templates").delete_prefix("/")
  end

  def self.engines
    @engines ||= ([Rails.application] + Rails::Engine.subclasses.select { _1.paths["app/views"].existent.any? }).index_by(&:engine_name)
  end

  def self.templates
    engines.transform_values do |engine|
      engine.paths["app/views"].existent.flat_map do |path|
        Dir.glob("**/*.*", base: File.join(path, templates_path))
      end
    end.reject { _2.empty? }
  end
end
