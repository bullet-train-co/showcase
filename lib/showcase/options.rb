require "active_support/option_merger"

class Showcase::Options
  include Enumerable

  def initialize(view_context)
    @view_context = view_context
    @options = []
    @order = [:name, :required, :type, :default, :description]
  end
  delegate :empty?, to: :@options

  #   Showcase.options.define :stimulus do
  #     def value(name, ...)
  #       option("data-#{@controller}-#{name}-value", ...)
  #     end
  #   end
  singleton_class.attr_reader :contexts
  @contexts = Hash.new { |h,k| h[k] = Class.new Context }

  def self.define(key, &block)
    contexts[key].class_eval(&block) # Lets users reopen an already defined context class.
  end

  #   showcase.options.stimulus controller: :welcome do |o|
  #     o.value :greeting, default: "Hello"
  #   end
  def context(key, **options, &block)
    context = self.class.contexts.fetch(key)
    context.new(@view_context, @options, **options).tap { yield _1 if block_given? }
  end

  def required(*arguments, **keywords, &block)
    if arguments.none?
      ActiveSupport::OptionMerger.new(self, required: true)
    else
      option(*arguments, **keywords, required: true, &block)
    end
  end

  def optional(*arguments, **keywords, &block)
    if arguments.none?
      ActiveSupport::OptionMerger.new(self, required: false)
    else
      option(*arguments, **keywords, required: false, &block)
    end
  end

  DEFAULT_OMITTED = Object.new

  def option(name, description = nil, required: false, type: nil, default: DEFAULT_OMITTED, **options, &block)
    description ||= @view_context.capture(&block).remove(/^\s+/).html_safe if block

    type ||= type_from_default(default)
    default = default == DEFAULT_OMITTED ? nil : default.inspect

    @options << options.with_defaults(name: name, default: default, type: type, description: description, required: required)
  end

  def headers
    @headers ||= @order | @options.flat_map(&:keys).uniq.sort
  end

  def each(&block)
    @options.each do |option|
      yield headers.index_with { option[_1] }
    end
  end

  private

  class Context < Showcase::Options
    def initialize(view_context, options, **kwargs)
      super(view_context)
      @options = options
      kwargs.each { instance_variable_set(:"@#{_1}", _2) }
    end
  end

  def type_from_default(default)
    case default
    when DEFAULT_OMITTED then String
    when true, false then "Boolean"
    when nil then "nil"
    else
      default.class
    end
  end
end
