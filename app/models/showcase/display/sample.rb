class Showcase::Display::Sample
  attr_reader :name, :events, :block

  def initialize(name, events = nil, block)
    @name, @events, @block = name, Array(events), block
  end

  def source
    file, starting_line = @block.source_location
    lines = File.readlines(file).slice!(starting_line..)

    index = lines.index { !_1.match?(/^\s+/) }
    lines.slice!(index..) if index

    lines.join("\n")
  end
end
