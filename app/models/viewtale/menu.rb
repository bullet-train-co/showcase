class Viewtale::Menu
  def self.items
    Rails.root.join("app/views/tales").children.map { Item.new _1.basename }
  end

  Item = Struct.new(:path)
end
