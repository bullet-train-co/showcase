require "test_helper"

class ShowcaseTest < Showcase::IntegrationTest
  test "it has a version number" do
    assert Showcase::VERSION
  end

  def assert_showcase_preview(path)
  end
end
