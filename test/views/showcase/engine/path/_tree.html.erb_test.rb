require "test_helper"

module Showcase::Engine::Path
  class TreePartialTest < ActionView::TestCase
    setup { view.extend Showcase::Engine.routes.url_helpers }

    setup    { @old_opens = Showcase.tree_opens }
    teardown { Showcase.tree_opens = @old_opens }

    test "tree_opens true" do
      Showcase.tree_opens = true
      render "showcase/engine/path/tree", tree: Showcase::Path::Tree.new(".")
      render "showcase/engine/path/tree", tree: Showcase::Path::Tree.new("helpers")
      assert_disclosure "Previews", expanded: true
      assert_disclosure "Helpers", expanded: true
    end

    test "tree_opens false" do
      Showcase.tree_opens = false
      render "showcase/engine/path/tree", tree: Showcase::Path::Tree.new(".")
      render "showcase/engine/path/tree", tree: Showcase::Path::Tree.new("helpers")
      assert_disclosure "Previews", expanded: false
      assert_disclosure "Helpers", expanded: false
    end

    test "tree_opens just root trees" do
      tree = Showcase::Path::Tree.new("deeply")
      tree.root = true
      tree.edge_for("nested")

      Showcase.tree_opens = ->(tree) { tree.root? }
      render "showcase/engine/path/tree", tree: Showcase::Path::Tree.new(".")
      render "showcase/engine/path/tree", tree: tree
      assert_disclosure "Previews", expanded: false
      assert_disclosure "Deeply", expanded: true
      assert_disclosure "Nested", expanded: false
    end

    test "params overrides tree_opens" do
      Showcase.tree_opens = false

      tree = Showcase::Path::Tree.new("deeply")
      tree.edge_for("nested") << Showcase::Path.new("deeply/nested/partial")

      @controller.params = { id: "deeply/nested/partial" }
      render "showcase/engine/path/tree", tree: tree
      assert_disclosure "Deeply", expanded: true
      assert_disclosure "Nested", expanded: true
    end
  end
end
