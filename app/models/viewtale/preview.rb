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

  class Example < Struct.new(:block)
    def source
      # TODO: Auto-derive source for an example by evaluating the code with a different output buffer
    end
  end
end
