module Showcase::Testing::Smokescreens
  def self.included(klass)
    tree = Showcase::Path.tree
    tree.flat_map(&:ordered_children).each do |path|
      klass.test "showcase renders #{path.id} successfully" do
        @path = path

        # TODO: call `path.page_for` with a view_context so we can assert on the generated DSL. E.g. count of 3 samples.
        visit showcase.page_path(@path.id)
        assert_showcase_preview
      end
    end

    klass.test "showcase isn't empty" do
      assert_not_empty tree, "Showcase couldn't find any samples to generate tests for"
    end
  end

  # Override `assert_showcase_preview` to add custom assertions.
  def assert_showcase_preview
    assert_text @path.basename.titleize
  end
end
