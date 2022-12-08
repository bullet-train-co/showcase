class Showcase::Display::Options
  include Enumerable

  def initialize
    @options = []
    @order = [ :name, :required, :type, :default, :description ]
  end
  delegate :empty?, to: :@options

  def required(*arguments, **keywords)
    option(*arguments, **keywords, required: true)
  end

  def optional(*arguments, **keywords)
    option(*arguments, **keywords, required: false)
  end

  def option(name, _type = nil, _description = nil, required:, type: _type, default: (no_default = true), **options)
    type ||= type_from_default(default) unless no_default

    @options << options.with_defaults(name: name.inspect, default: default.inspect, type: type, description: _description, required: required)
  end

  def headers
    @headers ||= @order | @options.flat_map(&:keys).uniq.sort
  end

  def each(&block)
    @options.each do |option|
      yield headers.map { option[_1] }
    end
  end

  private

  def type_from_default(default)
    case default
    when true, false then "Boolean"
    when nil         then "Nil"
    else
      default.class
    end
  end
end
