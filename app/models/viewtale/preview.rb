class Viewtale::Preview
  def self.find(path)
    if Dir.glob("app/views/tales/#{path}*", base: Rails.root.to_s).first
      new path
    end
  end

  attr_reader :name, :path

  def initialize(name)
    @name, @path = name, "tales/#{name}"
  end
end
