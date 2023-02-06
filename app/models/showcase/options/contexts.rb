module Showcase::Options::Contexts
  class Context < Showcase::Options
    def initialize(view_context, options, **kwargs)
      super(view_context)
      @options = options
      kwargs.each { instance_variable_set(:"@#{_1}", _2) }
    end
  end

  # showcase.options.context :stimulus, controller: :welcome
  def context(key, **options, &block)
    self.class.contexts[key].new(@view_context, @options, **options).tap do
      yield _1 if block_given?
    end
  end

  module ClassMethods
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
    end

    def contexts
      @contexts ||= {}
    end
  end

  def self.included(klass)
    klass.extend ClassMethods

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
