class Showcase::Display
  def self.find(path)
    if Dir.glob("app/views/showcases/#{path}*", base: Rails.root.to_s).first
      new path
    end
  end

  attr_reader :name, :path, :samples

  def initialize(name)
    @name, @path = name, "showcases/#{name}"
    @samples = []
  end

  def title(value = nil)
    @title = value if value
    @title
  end

  def description(value = nil)
    @description = value if value
    @description
  end

  def sample(name = nil, &block)
    @samples << Sample.new(name, block)
  end

  class Sample
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
