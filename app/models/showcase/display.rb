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

  def description(value = nil)
    @description = value if value
    @description
  end

  def sample(name = nil, &block)
    @samples << Sample.new(name, block)
  end

  def options(&block)
    @options ||= Options.new.tap { yield _1 if block_given? }
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

  class Options
    include Enumerable

    def initialize
      @options = []
      @order = [ :name, :required, :type, :default, :description ]
    end
    delegate :empty?, to: :@options

    def required(*arguments, **keywords)
      option(*arguments, **keywords, required: true)
    end

    def optional(*arguments, **keywords)
      option(*arguments, **keywords, required: false)
    end

    def option(name, _type = nil, _description = nil, required:, type: _type, default: (no_default = true), **options)
      type ||= type_from_default(default) unless no_default

      @options << options.with_defaults(name: name.inspect, default: default.inspect, type: type, description: _description, required: required)
    end

    def headers
      @headers ||= @order | @options.flat_map(&:keys).uniq.sort
    end

    def each(&block)
      @options.each do |option|
        yield headers.map { option[_1] }
      end
    end

    private

    def type_from_default(default)
      case default
      when true, false then "Boolean"
      when nil         then "Nil"
      else
        default.class
      end
    end
  end
end
