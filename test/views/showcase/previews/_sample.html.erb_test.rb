require "test_helper"

module Showcase::Previews
  class SamplePartialTest < ActionView::TestCase
    test "showcase/previews/sample renders its name and description" do
      sample = showcase_sample "A sample" do |partial|
        partial.description { "A description" }
      end

      render "showcase/engine/previews/sample", sample: sample

      assert_region "A sample" do |section|
        section.assert_element "showcase-sample" do |showcase_sample|
          showcase_sample.assert_link "A sample", href: "#a-sample"
          showcase_sample.assert_text "A description"
        end
      end
    end

    test "showcase/previews/sample renders a preview and its source" do
      sample = showcase_sample { "<pre>ERB</pre>" }

      render "showcase/engine/previews/sample", sample: sample

      assert_element "showcase-sample" do |showcase_sample|
        showcase_sample.assert_text "ERB"
        showcase_sample.assert_disclosure "View Source", expanded: false
      end
    end

    test "showcase/previews/sample renders a region to capture JavaScript events" do
      sample = showcase_sample("with events", events: "click") { "<pre>ERB</pre>" }

      render "showcase/engine/previews/sample", sample: sample

      assert_element "showcase-sample", events: ["click"] do |showcase_sample|
        showcase_sample.assert_region "JavaScript Events" do |section|
          section.assert_element data: {showcase_sample_target: "relay"}
        end
      end
    end

    def showcase_sample(name = "sample name", **options, &block)
      preview = Showcase::Preview.new(view, id: "showcase_test")
      preview.sample(name, **options, &block).first
    end
  end
end
