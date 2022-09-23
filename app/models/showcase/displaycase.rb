class Showcase::Displaycase
  include Enumerable

  mattr_reader :root, default: Rails.root.join("app/views/showcases")

  def self.all
    Dir.glob("*", base: root).map { new _1 }.sort_by(&:name)
  end

  attr_reader :name, :displays

  def initialize(name)
    @name, @displays = name, []
    find_displays
  end
  delegate :each, :<<, to: :displays

  def find(id)
    Showcase::Display.new(id).tap { _1.group = self }
  end

  private

  def find_displays
    Dir.children(root.join(name)).map { self << find(_1) }
    displays.sort_by!(&:name)
  end
end
