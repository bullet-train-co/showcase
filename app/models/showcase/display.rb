class Showcase::Display
  autoload :Sample,  "showcase/display/sample"
  autoload :Options, "showcase/display/options"

  attr_reader :badges, :samples

  def initialize(view_context, title: nil)
    @view_context, @badges, @samples = view_context, [], []
    title title
  end

  def title(content = nil)
    @title = content if content
    @title
  end

  def description(content = nil, &block)
    @description = content || @view_context.capture(&block) if content || block_given?
    @description
  end

  def badge(*badges)
    @badges.concat badges
  end

  def sample(name, **options, &block)
    @samples << sample = Sample.new(@view_context, name, **options)

    if block.arity.zero?
      sample.collect(&block)
    else
      @view_context.capture(sample, &block)
    end
  end

  def options
    @options ||= Options.new(@view_context).tap { yield _1 if block_given? }
  end
end
