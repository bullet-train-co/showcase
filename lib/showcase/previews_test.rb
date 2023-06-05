class Showcase::PreviewsTest < ActionView::TestCase
  setup { view.extend Showcase::EngineController._helpers }

  def self.inherited(test_class)
    super
    test_class.prepare
  end

  def self.prepare
    tree = Showcase::Path.tree
    tree.flat_map(&:ordered_paths).each do |path|
      test "Showcase: automatically renders showcase/previews/#{path.id}" do
        render "showcase/engine/preview", preview: path.preview_for(view)
        assert_showcase_preview(path.id)
      end
    end

    test "Showcase: isn't empty" do
      assert_not_empty tree, "Showcase couldn't find any samples to generate tests for"
    end
  end

  def self.test(name = nil, showcase: nil, &block)
    if name
      super(name, &block)
    else
      super "Showcase: showcase/previews/#{showcase}" do
        path = Showcase::Path.new(showcase)
        render "showcase/engine/preview", preview: path.preview_for(view)

        assert_showcase_preview(path.id)
        instance_eval(&block)
      end
    end
  end

  # Override `assert_showcase_preview` to add custom assertions.
  def assert_showcase_preview(id)
  end
end
