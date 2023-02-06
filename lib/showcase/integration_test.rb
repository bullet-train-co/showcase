class Showcase::IntegrationTest < ActionDispatch::IntegrationTest
  def self.inherited(test_class)
    super
    test_class.prepare
  end

  def self.autorun
    at_exit { prepare unless subclasses.any? }
  end

  def self.prepare
    tree = Showcase::Path.tree
    tree.flat_map(&:ordered_paths).each do |path|
      test "Showcase: GET showcase/previews/#{path.id} renders successfully" do
        get showcase.preview_path(path.id)

        assert_response :ok
        assert_showcase_preview(path.id)
      end
    end

    test "Showcase: isn't empty" do
      assert_not_empty tree, "Showcase couldn't find any samples to generate tests for"
    end
  end

  # Override `assert_showcase_preview` to add custom assertions.
  def assert_showcase_preview(id)
  end
end
