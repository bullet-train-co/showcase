class Showcase::Path
  class Tree < Struct.new(:id, :paths)
    def root?
      id == "."
    end
  end

  def self.tree
    all.group_by(&:dirname).map { Tree.new _1, _2 }
  end

  def self.all
    Showcase.filenames.map { new _1 }.sort_by!(&:id)
  end

  attr_reader :id, :dirname, :basename

  def initialize(path)
    @id = path.split(".").first
    @dirname, @basename = File.split(@id)
  end

  def template_path
    "showcase/#{id}"
  end

  def display_for(view_context, title: basename.titleize)
    Showcase::Display.new(view_context, title: title)
  end
end
