class Showcase::IntegrationTest < ActionDispatch::IntegrationTest
  def self.inherited(test_class)
    super

    tree = Showcase::Path.tree
    tree.flat_map(&:ordered_children).each do |path|
      test_class.test "Showcase: GET showcase/pages/#{path.id} renders successfully" do
        get showcase.page_path(path.id)

        assert_response :ok
        assert_showcase_preview(path.id)
      end
    end

    test_class.test "Showcase: isn't empty" do
      assert_not_empty tree, "Showcase couldn't find any samples to generate tests for"
    end
  end

  # Override `assert_showcase_preview` to add custom assertions.
  def assert_showcase_preview(id)
  end
end
