class Showcase::Display::Sample
  attr_reader :name, :id, :details
  attr_reader :source

  def initialize(view_context, name, id: name.parameterize, **details)
    @view_context = view_context
    @name, @id, @details = name, id, details
  end

  def description(content = nil, &block)
    @description = content || @view_context.capture(&block) if content || block
    @description
  end

  def preview(&block)
    block ? @preview = @view_context.capture(&block) : @preview
  end

  def extract(&block)
    @source = Showcase.sample_renderer.call \
      extract_inner_block_lines_from_matched_indentation_starting_at(block)
  end

  private

  def extract_inner_block_lines_from_matched_indentation_starting_at(block)
    file, starting_index = block.source_location
    first_line, *lines = File.readlines(file).from(starting_index - 1)

    indentation = first_line.match(/^\s+(?=<%)/).to_s
    matcher = /^#{indentation}\S/

    index = lines.index { _1.match?(matcher) }
    lines.slice!(index..) if index
    lines
  end
end
