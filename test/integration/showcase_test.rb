require "test_helper"

class ShowcaseTest < Showcase::IntegrationTest
  test "it has a version number" do
    assert Showcase::VERSION
  end

  test "defines tests reflectively" do
    refute_empty self.class.runnable_methods.grep(/\Atest_Showcase/)
  end

  test "defines tests for deeply nested previews" do
    refute_empty self.class.runnable_methods.grep(%r{renders_showcase/previews/deeply/nested/partial})
  end

  test showcase: "combobox" do
    assert_element id: "basic" do
      assert_text "This is totally a combobox, for sure."
    end
  end

  test showcase: "combobox", id: "basic" do
    assert_text "This is totally a combobox, for sure."
  end
end
