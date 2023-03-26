require "test_helper"

class ShowcaseTest < Showcase::PreviewsTest
  test "it has a version number" do
    assert Showcase::VERSION
  end

  test "defines tests reflectively" do
    assert_method /\Atest_Showcase/
  end

  test "defines tests for deeply nested previews" do
    assert_method %r{renders_showcase/previews/deeply/nested/partial}
  end

  test showcase: "components/combobox" do
    assert_element id: "basic" do
      assert_text "This is totally a combobox, for sure."
    end
  end

  test "showcase generated a components/combobox test" do
    assert_method "test_Showcase:_showcase/previews/components/combobox"
  end

  test showcase: "helpers/upcase_helper" do
    assert_element id: "with-extract" do
      assert_text /<%= upcase_string "extract" %>\Z/, normalize_ws: true
    end
  end

  private

  def assert_method(name)
    refute_empty self.class.runnable_methods.grep(name),
      "Found no generated test in: \n#{self.class.runnable_methods.join("\n")}"
  end
end
