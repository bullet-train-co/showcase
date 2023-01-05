class Showcase::Path
  class Tree < Struct.new(:id, :children)
    def name
      root? ? "Templates" : id
    end

    def root?
      id == "."
    end

    def tree?
      true
    end
  end

  def self.tree
    paths = Showcase.templates.map { new _1 }.sort_by!(&:id)
    paths.group_by(&:dirname).map { Tree.new _1, _2 }
  end

  attr_reader :id, :dirname, :basename

  def initialize(path)
    @id = path.split(".").first
    @dirname, @basename = File.split(@id)
  end

  def tree?
    false
  end

  def page_for(view_context)
    Showcase::Page.new(view_context, id: id, title: basename.titleize).tap(&:render_template)
  end
end
