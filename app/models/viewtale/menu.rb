class Viewtale::Menu
  def self.items
    Rails.root.join("app/views/tales").children.map { Item.new _1 }
  end

  class Item
    attr_reader :path, :name

    def initialize(path)
      path = path.basename.to_s
      @path, @name = path, path.split(".").first
    end
  end
end
