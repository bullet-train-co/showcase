module Showcase::Page::Options::Contexts
  class Context
    delegate :required, :optional, :option, to: :@options

    def initialize(options, **kwargs)
      @options = options
      kwargs.each { instance_variable_set(:"@#{_1}", _2) }
    end
  end

  #   Showcase.options.context :stimulus do
  #     def value(name, ...)
  #       option("data-#{@controller}-#{name}-value", ...)
  #     end
  #   end
  #
  #   showcase.options.stimulus controller: :welcome do |o|
  #     o.value :greeting, default: "Hello"
  #   end
  def context(key, *accessors, &block)
    contexts[key] ||= Class.new(Context)
    contexts[key].class_eval(&block) # Lets users reopen an already defined context class.

    class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{key}(**kwargs)
        self.class.contexts[:#{key}].new(self, **kwargs).tap do
          yield _1 if block_given?
        end
      end
    RUBY
  end

  def contexts
    @contexts ||= {}
  end

  def self.extended(klass)
    klass.context :stimulus do
      def target(name, ...)
        option(%(data-#{@controller}-target="#{name}"), ...)
      end

      def value(name, ...)
        option("data-#{@controller}-#{name}-value", ...)
      end

      def class(name, ...)
        option("data-#{@controller}-#{name}-class", ...)
      end

      def action(name, ...)
        option(%(data-action="#{name}"), ...)
      end
    end

    klass.context :nice_partials do
      def content_block(*arguments, **options, &block)
        option(*arguments, **options, type: "Content Block", &block)
      end
    end
  end
end
