require_relative "showcase/version"

module Showcase
  autoload :PreviewsTest, "showcase/previews_test"
  autoload :RouteHelper,  "showcase/route_helper"
  autoload :Options,      "showcase/options"

  singleton_class.attr_reader :tree_opens

  def self.tree_opens=(opens)
    @tree_opens = opens.respond_to?(:call) ? opens : proc { opens }
  end
  self.tree_opens = true # All open by default

  singleton_class.attr_writer :sample_renderer

  def self.sample_renderer
    @sample_renderer ||=
      begin
        gem "rouge" # Activate the app-bundled Rouge gem to setup default syntax highlighting.
        require "rouge"

        formatter = Rouge::Formatters::HTML.new
        @sample_renderer = ->(source, syntax) do
          lexed = Rouge::Lexer.find(syntax).lex(source)
          formatter.format(lexed).html_safe
        end
      rescue LoadError
        proc { _1 }
      end
  end

  def self.previews
    Showcase::EngineController.view_paths.map(&:path).flat_map do |root|
      Dir.glob("**/*.*", base: File.join(root, "showcase/previews"))
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
