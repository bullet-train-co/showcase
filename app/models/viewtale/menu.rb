class Viewtale::Menu
  def self.items
    Rails.root.join("app/views/tales").children.map { Item.new _1 }
  end

  class Item
    attr_reader :path, :name
    attr_reader :children

    def initialize(path)
      path = path.basename.to_s
      @path, @name = path, path.split(".").first

      @children = []
    end

    def one?
      children.empty?
    end
  end
end
