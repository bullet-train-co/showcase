class Showcase::Path
  class Tree < Struct.new(:id, :children)
    def initialize(id, children = [])
      super
    end
    delegate :<<, to: :children

    to_partial_path = "showcase/path/tree"
    define_method(:to_partial_path) { to_partial_path }

    def name
      root? ? "Templates" : id
    end

    def root?
      id == "."
    end

    def partition
      children.partition { _1.is_a?(Tree) }
    end

    def self.index(...)
      new(:discardable_root).tap { _1.index(...) }.children
    end

    def index(paths)
      paths.each do |path|
        ids = yield path
        ids.inject(self, :edge_for) << path
      end
    end

    def edge_for(id)
      find(id) || insert(id)
    end

    private

    def find(id)   = children.find { _1.id == id }
    def insert(id) = self.class.new(id).tap { self << _1 }
  end

  def self.tree
    paths = Showcase.templates.map { new _1 }.sort_by!(&:id)
    Tree.index(paths, &:segments)
  end

  attr_reader :id, :segments, :basename

  def initialize(path)
    @id = path.split(".").first
    @basename = File.basename(@id)
    @segments = File.dirname(@id).split("/")
  end

  to_partial_path = "showcase/path/path"
  define_method(:to_partial_path) { to_partial_path }

  def page_for(view_context)
    Showcase::Page.new(view_context, id: id, title: basename.titleize).tap(&:render_template)
  end
end
