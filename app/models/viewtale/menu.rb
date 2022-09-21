class Viewtale::Menu
  def self.items
    Rails.root.join("app/views/tales").children.map { Item.new _1 }
  end

  class Item
    attr_reader :path, :name, :children

    def initialize(path)
      @path = path
      @name = path.basename.to_s.split(".").first
      @children = path.children.map { self.class.new _1 } rescue []
    end

    def one?
      children.empty?
    end
  end
end
