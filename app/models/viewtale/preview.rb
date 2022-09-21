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
    class Buffer
      def initialize
        @raw_buffer = +""
      end

      def safe_append=(value)
        @raw_buffer << "<%= #{value} %>" unless value.nil?
      end
    end

    def source
      @output_buffer = Buffer.new
      instance_exec(&block)
      @output_buffer.presence
    ensure
      @output_buffer = nil
    end

    private attr_reader :output_buffer
  end
end
