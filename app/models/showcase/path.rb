class Showcase::Path
  class Tree < Struct.new(:id, :paths)
    def self.all
      Showcase::Path.all.group_by(&:dirname).map { new _1, _2 }
    end

    def root?
      id == "."
    end
  end

  def self.all
    Showcase.filenames.map { new _1 }.sort_by!(&:id)
  end

  attr_reader :id, :dirname, :basename

  def initialize(path)
    @id = path.split(".").first
    @dirname, @basename = File.split(@id)
  end
end
