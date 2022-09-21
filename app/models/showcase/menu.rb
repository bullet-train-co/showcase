class Showcase::Menu
  def self.items
    root = Rails.root.join("app/views/tales").to_s
    paths = Dir.glob("**/*", base: root)
    paths.reject! { File.directory?(File.join(root, _1)) }
    paths.group_by { File.split(_1).first }.flat_map { Item.build _1, _2 }
  end

  class Item
    def self.build(directory, children)
      if directory == "."
        children.map { new _1 }
      else
        new(directory, children.map { new _1 })
      end
    end

    attr_reader :path, :name, :children

    def initialize(path, children = [])
      @path = path.split(".").first || path
      @dirname, @name = File.split(@path)

      @children = children
    end

    def one?
      children.empty?
    end
  end
end
