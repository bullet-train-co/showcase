class Showcase::Sample
  attr_reader :name, :id, :events, :details
  attr_reader :rendered, :source, :instrumented

  def initialize(view_context, name, description: nil, id: name.parameterize, syntax: :erb, events: nil, **details)
    @view_context = view_context
    @name, @id, @syntax, @details = name, id, syntax, details
    @events = Array(events)
    description description if description
  end

  def description(content = nil, &block)
    @description = content || @view_context.capture(&block) if content || block_given?
    @description
  end

  def evaluate(&block)
    if block.arity.zero?
      consume(&block)
    else
      @view_context.capture(self, &block)
    end
  end

  def consume(&block)
    render(&block)
    extract_source(&block)
  end

  def render(&block)
    # TODO: Remove `is_a?` check when Rails 6.1 support is dropped.
    assigns = proc { @instrumented = _1 if _1.is_a?(ActiveSupport::Notifications::Event) }
    ActiveSupport::Notifications.subscribed(assigns, "render_partial.action_view") do
      @rendered = @view_context.capture(&block)
    end
  end

  def extract_source(&block)
    source = extract_source_block_via_matched_indentation_from(*block.source_location)
    @source = @view_context.instance_exec(source, @syntax, &Showcase.sample_renderer)
  end

  private

  def extract_source_block_via_matched_indentation_from(file, source_location_index)
    # `Array`s are zero-indexed, but `source_location` indexes are not, hence `pred`.
    starting_line, *lines = File.readlines(file).slice(source_location_index.pred..)

    indentation = starting_line.match(/^\s+/).to_s
    matcher = /^#{indentation}\S/

    index = lines.index { _1.match?(matcher) }
    lines.slice!(index..) if index
    lines.join.strip_heredoc
  end
end
