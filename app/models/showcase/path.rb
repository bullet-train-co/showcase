class Showcase::Path
  class Tree < Struct.new(:id, :children, :root)
    def initialize(id, children = [])
      super(id, children, false)
    end
    alias_method :root?, :root
    delegate :<<, to: :children

    cached_partial_path = "showcase/engine/path/tree"
    define_method(:to_partial_path) { cached_partial_path }

    def name
      id == "." ? "Previews" : id
    end

    def open?
      Showcase.tree_opens.call(self)
    end

    def active?(id)
      children.any? { _1.active?(id) }
    end

    def ordered_children
      children.partition { !_1.is_a?(Tree) }.flatten
    end

    def ordered_paths
      children.flat_map { _1.is_a?(Tree) ? _1.ordered_paths : _1 }
    end

    def self.index(paths)
      paths.each_with_object new(:discardable_root) do |path, root|
        yield(path).reduce(root, :edge_for) << path
      end.children.sort_by(&:id).each { _1.root = true }
    end

    def edge_for(id)
      find(id) || insert(id)
    end

    private

    def find(id)
      children.find { _1.id == id }
    end

    def insert(id)
      self.class.new(id).tap { self << _1 }
    end
  end

  def self.tree
    paths = Showcase.previews.map { new _1 }.sort_by!(&:id)
    Tree.index(paths, &:segments)
  end

  attr_reader :id, :segments, :basename

  def initialize(path)
    @id = path.split(".").first.delete_prefix("_").sub(/\/_/, "/")
    @basename = File.basename(@id)
    @segments = File.dirname(@id).split("/")
  end

  cached_partial_path = "showcase/engine/path/path"
  define_method(:to_partial_path) { cached_partial_path }

  def active?(id)
    self.id == id
  end

  def preview_for(view_context)
    Showcase::Preview.new(view_context, id: id, title: basename.titleize).tap(&:render_associated_partial)
  end
end
