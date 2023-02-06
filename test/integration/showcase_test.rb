require "test_helper"

class ShowcaseTest < Showcase::IntegrationTest
  test "it has a version number" do
    assert Showcase::VERSION
  end

  test "defines tests reflectively" do
    refute_empty self.class.runnable_methods.grep(/\Atest_Showcase/)
  end

  test "defines tests for deeply nested previews" do
    refute_empty self.class.runnable_methods.grep(%r{GET_showcase/previews/deeply/nested/partial})
  end

  def assert_showcase_preview(path)
  end
end
