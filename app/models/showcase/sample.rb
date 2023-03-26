class Showcase::Sample
  attr_reader :name, :id, :events, :details
  attr_reader :source, :instrumented

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

  def collect(&block)
    if block.arity.zero?
      preview(&block)
      extract(&block)
    else
      @view_context.capture(self, &block)
    end
  end

  def preview(&block)
    return @preview unless block_given?

    # TODO: Remove `is_a?` check when Rails 6.1 support is dropped.
    assigns = proc { @instrumented = _1 if _1.is_a?(ActiveSupport::Notifications::Event) }
    ActiveSupport::Notifications.subscribed(assigns, "render_partial.action_view") do
      @preview = @view_context.capture(&block)
    end
  end

  def extract(&block)
    source = extract_source_block_via_matched_indentation_from(*block.source_location)
    @source = @view_context.instance_exec(source, @syntax, &Showcase.sample_renderer)
  end

  private

  def extract_source_block_via_matched_indentation_from(file, starting_index)
    starting_line, *lines = File.readlines(file).slice(starting_index.pred..)

    indentation = starting_line.match(/^\s+/).to_s
    matcher = /^#{indentation}\S/

    index = lines.index { _1.match?(matcher) }
    lines.slice!(index..) if index
    lines.join.strip_heredoc
  end
end
