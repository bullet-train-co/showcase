class Showcase::Path
  class Tree < Struct.new(:id, :children)
    def initialize(id, children = [])
      super
    end
    delegate :<<, to: :children

    def name
      root? ? "Templates" : id
    end

    def root?
      id == "."
    end

    def tree?
      true
    end

    def self.sieve(paths, &block)
      new(:discardable_root).tap { _1.sieve(paths, &block) }.children
    end

    def sieve(paths)
      paths.each do |path|
        ids = yield path
        ids.inject(self, :edge_for) << path
      end
    end

    def edge_for(id)
      find(id) || insert(id)
    end

    protected

    def find(id)   = children.find { _1.id == id }
    def insert(id) = self.class.new(id).tap { self << _1 }
  end

  def self.tree
    paths = Showcase.templates.map { new _1 }.sort_by!(&:id)
    Tree.sieve(paths) { _1.dirname.split("/") }
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
