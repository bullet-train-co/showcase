namespace :showcase do
  namespace :install do
    INTEGRATION_TEST_PATH = "test/integration/showcase_test.rb"

    desc "Install Showcase integration testing in #{INTEGRATION_TEST_PATH}"
    task :integration_test do
      mkdir_p File.dirname(INTEGRATION_TEST_PATH)
      File.write INTEGRATION_TEST_PATH, <<~RUBY
        require "test_helper"

        class ShowcaseTest < Showcase::IntegrationTest
          def assert_showcase_preview(id)
            # Add any custom preview response body assertions here.
          end
        end
      RUBY
    end
  end
end
