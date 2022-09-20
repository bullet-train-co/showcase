class Viewtale::Preview
  def self.find(path)
    # TODO: Sanitize the path?
    contents = Rails.root.join("app/views/tales/#{path}").read
    new path, contents
  end

  attr_reader :path, :contents

  def initialize(path, contents)
    @path, @contents = path, contents
  end
end
