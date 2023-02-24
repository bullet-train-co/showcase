class Showcase::PreviewsTest < ActionView::TestCase
  def self.inherited(test_class)
    super
    test_class.prepare
  end

  def self.autorun
    at_exit { prepare unless subclasses.any? }
  end

  def self.prepare
    tests Showcase::EngineController._helpers

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

  def self.test(name = nil, showcase: nil, id: nil, &block)
    case
    when name then super(name, &block)
    when id && showcase.nil? then raise ArgumentError, "can't test a sample without a showcase"
    else
      super "Showcase: showcase/previews/#{showcase} #{"sample #{id}" if id}".squish do
        path = Showcase::Path.new(showcase)
        render "showcase/engine/preview", preview: path.preview_for(view)

        assert_showcase_preview(path.id)
        assert_element(id: id || path.id) { instance_eval(&block) }
      end
    end
  end

  # Override `assert_showcase_preview` to add custom assertions.
  def assert_showcase_preview(id)
  end
end
