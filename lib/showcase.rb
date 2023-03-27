require_relative "showcase/version"

# Activate the app-bundled Rouge gem to setup default syntax highlighting.
begin
  gem "rouge"
  require "rouge"
rescue LoadError
end

module Showcase
  autoload :PreviewsTest, "showcase/previews_test"
  autoload :LinkHelper,   "showcase/link_helper"
  autoload :RouteHelper,  "showcase/route_helper"
  autoload :Options,      "showcase/options"

  singleton_class.attr_accessor :sample_renderer
  @sample_renderer = proc { _1 }

  if defined?(Rouge)
    Formatter = Rouge::Formatters::HTML.new

    @sample_renderer = ->(source, syntax) do
      lexed = Rouge::Lexer.find(syntax).lex(source)
      Showcase::Formatter.format(lexed).html_safe
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
