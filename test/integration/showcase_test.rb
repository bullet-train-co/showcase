require "test_helper"

class ShowcaseTest < Showcase::IntegrationTest
  test "it has a version number" do
    assert Showcase::VERSION
  end

  test "defines tests reflectively" do
    refute_empty self.class.runnable_methods.grep(/\Atest_Showcase/)
  end

  def assert_showcase_preview(path)
  end
end
