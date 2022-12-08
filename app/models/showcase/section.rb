class Showcase::Section
  include Enumerable

  mattr_reader :root, default: Rails.root.join("app/views/showcases")

  def self.all(view_context)
    Dir.glob("*", base: root).map { new(view_context, _1).tap(&:find_displays) }.sort_by(&:name)
  end

  attr_reader :name, :displays

  def initialize(view_context, name)
    @view_context, @name, @displays = view_context, name, []
  end
  delegate :each, :<<, to: :displays

  def find(id)
    Showcase::Display.new(@view_context, title: id)
  end

  protected def find_displays
    Dir.children(root.join(name)).map { self << find(_1) }
    displays.sort_by!(&:title)
  end
end
