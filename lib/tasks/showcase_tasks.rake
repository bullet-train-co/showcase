namespace :showcase do
  namespace :install do
    PREVIEWS_TEST_PATH = "test/views/showcase_test.rb"

    desc "Install Showcase previews testing in #{PREVIEWS_TEST_PATH}"
    task :previews_test do
      mkdir_p File.dirname(PREVIEWS_TEST_PATH)
      File.write PREVIEWS_TEST_PATH, <<~RUBY
        require "test_helper"

        class ShowcaseTest < Showcase::PreviewsTest
          def assert_showcase_preview(id)
            # Add any custom preview response body assertions here.
          end
        end
      RUBY
    end
  end
end
