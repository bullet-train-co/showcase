class Viewtale::Menu
  def self.items
    Item.extract Rails.root.join("app/views/tales")
  end

  class Item
    attr_reader :path, :name, :children

    def self.extract(path)
      path.children.map { new _1 }
    end

    def initialize(path)
      @path = path
      @name = path.basename.to_s.split(".").first
      @children = self.class.extract(path) rescue []
    end

    def one?
      children.empty?
    end
  end
end
