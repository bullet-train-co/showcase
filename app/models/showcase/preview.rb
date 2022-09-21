class Showcase::Preview
  def self.find(path)
    if Dir.glob("app/views/showcases/#{path}*", base: Rails.root.to_s).first
      new path
    end
  end

  attr_reader :name, :path, :examples

  def initialize(name)
    @name, @path = name, "showcases/#{name}"
    @examples = []
  end

  def title(value = nil)
    @title = value if value
    @title
  end

  def description(value = nil)
    @description = value if value
    @description
  end

  def example(name = nil, &block)
    @examples << Example.new(name, block)
  end

  class Example
    attr_reader :name, :block

    def initialize(name = nil, block)
      @name, @block = name, block
    end

    def source
      file, starting_line = @block.source_location
      lines = File.readlines(file).slice!(starting_line..)

      index = lines.index { !_1.match?(/^\s+/) }
      lines.slice!(index..) if index

      lines.join("\n")
    end
  end
end
