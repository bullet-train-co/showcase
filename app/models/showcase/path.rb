class Showcase::Path
  class Tree < Struct.new(:id, :children)
    def name
      root? ? "Pages" : id
    end

    def root?
      id == "."
    end

    def tree?
      true
    end
  end

  def self.tree
    Showcase.templates.map do |engine_id, templates|
      contents = templates.map { new engine_id, _1 }.sort_by!(&:id).group_by(&:dirname).map { Tree.new _1, _2 }
      Tree.new(engine_id, contents)
    end
  end

  attr_reader :engine_id, :id, :dirname, :basename

  def initialize(engine_id, path)
    @engine_id = engine_id
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
