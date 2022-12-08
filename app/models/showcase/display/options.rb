class Showcase::Display::Options
  include Enumerable

  def initialize(view_context)
    @view_context = view_context
    @options = []
    @order = [:name, :required, :type, :default, :description]
  end
  delegate :empty?, to: :@options

  def required(*arguments, **keywords, &block)
    option(*arguments, **keywords, required: true, &block)
  end

  def optional(*arguments, **keywords, &block)
    option(*arguments, **keywords, required: false, &block)
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
