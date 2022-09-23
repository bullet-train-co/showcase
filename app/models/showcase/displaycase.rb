class Showcase::Displaycase
  include Enumerable

  mattr_reader :root, default: Rails.root.join("app/views/showcases")

  def self.all
    Dir.glob("*", base: root).map { new(_1).tap(&:find_displays) }.sort_by(&:name)
  end

  attr_reader :name, :displays

  def initialize(name)
    @name, @displays = name, []
  end
  delegate :each, :<<, to: :displays

  def find(id)
    Showcase::Display.new(self, id)
  end

  protected def find_displays
    Dir.children(root.join(name)).map { self << find(_1) }
    displays.sort_by!(&:name)
  end
end
