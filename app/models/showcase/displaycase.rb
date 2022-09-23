class Showcase::Displaycase
  include Enumerable

  mattr_reader :root, default: Rails.root.join("app/views/showcases")

  def self.all
    Dir.glob("*", base: root).map { self[_1] }.sort_by(&:name)
  end

  def self.[](name)
    @groups ||= {}
    @groups[name] ||= new(name)
  end

  attr_reader :name, :displays

  def initialize(name)
    @name, @displays = name, []
    find_displays
  end
  delegate :each, to: :displays

  def <<(display)
    display.group = self
    displays << display
  end

  def find(id)
    displays.find { _1.name == id }
  end

  private

  def find_displays
    Dir.children(root.join(name)).map { self << Showcase::Display.new(_1) }
  end
end
