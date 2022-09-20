class Viewtale::Preview
  def self.find(path)
    if file = Dir.glob("app/views/tales/#{path}*", base: Rails.root.to_s).first
      new "tales/#{path}"
    end
  end

  attr_reader :path

  def initialize(path)
    @path = path
  end
end
