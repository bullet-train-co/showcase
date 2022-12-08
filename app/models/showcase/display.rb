class Showcase::Display
  autoload :Sample,  "showcase/display/sample"
  autoload :Options, "showcase/display/options"

  attr_reader :name, :group, :samples

  def initialize(group, path)
    @group = group
    @name  = path.split(".").first
    @samples = []
  end

  def template_path
    "showcases/#{group.name}/#{name}"
  end

  def description(value = nil)
    @description = value if value
    @description
  end

  def sample(name, events: nil, &block)
    @samples << Sample.new(name, events, block)
  end

  def options(&block)
    @options ||= Options.new.tap { yield _1 if block_given? }
  end
end
