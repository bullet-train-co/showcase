class Viewtale::Preview
  def self.find(path)
    if Dir.glob("app/views/tales/#{path}*", base: Rails.root.to_s).first
      new path
    end
  end

  attr_reader :name, :path, :examples

  def initialize(name)
    @name, @path = name, "tales/#{name}"
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

  def example(&block)
    @examples << Example.new(block)
  end

  class Example
    def initialize(block)
      @block = block
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
