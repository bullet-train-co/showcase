class Showcase::Section
  include Enumerable

  mattr_reader :root, default: Rails.root.join("app/views/showcases")

  def self.all(view_context)
    Dir.glob("*", base: root).map { new(view_context, _1).tap(&:find_displays) }.sort_by(&:title)
  end

  attr_reader :title, :displays

  def initialize(view_context, title)
    @view_context, @title, @displays = view_context, title, []
  end
  delegate :each, :<<, to: :displays

  def find(id)
    Showcase::Display.new(@view_context, title: id)
  end

  protected def find_displays
    Dir.children(root.join(title)).map { self << find(_1) }
    displays.sort_by!(&:title)
  end
end
