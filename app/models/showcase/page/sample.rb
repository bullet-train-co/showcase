class Showcase::Page::Sample
  attr_reader :name, :id, :events, :details
  attr_reader :source

  def initialize(view_context, name, description: nil, id: name.parameterize, events: nil, **details)
    @view_context = view_context
    @name, @id, @details = name, id, details
    @events = Array(events)
    description description if description
  end

  def description(content = nil, &block)
    @description = content || @view_context.capture(&block) if content || block_given?
    @description
  end

  def collect(&block)
    preview(&block)
    extract(&block)
  end

  def preview(&block)
    block_given? ? @preview = @view_context.capture(&block) : @preview
  end

  def extract(&block)
    lines = extract_block_lines_via_matched_indentation_from(*block.source_location)
    @source = @view_context.instance_exec(lines, &Showcase.sample_renderer)
  end

  private

  def extract_block_lines_via_matched_indentation_from(file, starting_index)
    first_line, *lines = File.readlines(file).from(starting_index - 1)

    indentation = first_line.match(/^\s+(?=\b)/).to_s
    matcher = /^#{indentation}\S/

    index = lines.index { _1.match?(matcher) }
    lines.slice!(index..) if index
    lines
  end
end
