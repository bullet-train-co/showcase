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
    context = self.class.contexts.fetch(key)
    context.new(@view_context, @options, **options).tap { yield _1 if block_given? }
  end

  module ClassMethods
    #   Showcase.options.define :stimulus do
    #     def value(name, ...)
    #       option("data-#{@controller}-#{name}-value", ...)
    #     end
    #   end
    #
    #   showcase.options.stimulus controller: :welcome do |o|
    #     o.value :greeting, default: "Hello"
    #   end
    attr_reader :contexts

    def define(key, &block)
      contexts[key].class_eval(&block) # Lets users reopen an already defined context class.
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
    klass.instance_variable_set :@contexts, Hash.new { |h,k| h[k] = Class.new Context }

    klass.define :stimulus do
      def target(name, ...)
        option(%(data-#{@controller}-target="#{name}"), ...)
      end

      def value(name, ...)
        option("data-#{@controller}-#{name}-value", ...)
      end

      def class(name, ...)
        option("data-#{@controller}-#{name}-class", ...)
      end

      def outlet(name, ...)
        option("data-#{@controller}-#{name}-outlet", ...)
      end

      def action(name, ...)
        option(%(data-action="#{name}"), ...)
      end
    end

    klass.define :nice_partials do
      def content_block(*arguments, **options, &block)
        option(*arguments, **options, type: "Content Block", &block)
      end
    end
  end
end
