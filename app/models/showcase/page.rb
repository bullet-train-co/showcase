class Showcase::Page
  autoload :Sample,  "showcase/page/sample"
  autoload :Options, "showcase/page/options"

  attr_reader :id, :badges, :samples

  def initialize(view_context, id:, title: nil)
    @view_context, @id = view_context, id
    @badges, @samples = [], []
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

  def render_template
    @view_context.render template: id, prefixes: [Showcase.templates_path], locals: { showcase: self }
    nil
  end
end
