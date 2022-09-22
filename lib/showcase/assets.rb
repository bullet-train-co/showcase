class Showcase::Assets
  def self.write(&block)
    @writer = block
  end

  def self.call(view_context)
    raise "Showcase::Assets.write should be called in an initializer" unless @writer
    new(view_context).instance_exec(&@writer)
  end

  def initialize(view_context)
    @view_context = view_context
  end

  def method_missing(...)
    @view_context.concat @view_context.send(...)
  end
end
