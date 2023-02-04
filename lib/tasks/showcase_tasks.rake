namespace :showcase do
  namespace :install do
    SMOKESCREEN_TEST_PATH = "test/integration/showcase/smokescreen_test.rb"

    desc "Install Showcase smokescreen testing in #{SMOKESCREEN_TEST_PATH}"
    task :smokescreen_test do
      mkdir_p SMOKESCREEN_TEST_PATH
      File.write SMOKESCREEN_TEST_PATH, <<~RUBY
        require "test_helper"

        class Showcase::SmokescreenTest < Showcase::IntegrationTest
          def assert_showcase_preview(path)
            # Add any custom page response body assertions here.
          end
        end
      RUBY
    end
  end

#   desc "Pass a directory relative to app/views to copy over"
#   task :copy do |t, directory|
#     prefix = "app/views/#{directory}"
#
#     Dir.glob(File.join(Dir.pwd, prefix, "**/*.*")).each do |filename|
#       new_filename = filename.sub(directory, Showcase.templates_path).sub(/\/_/, "/")
#       mkdir_p File.dirname(new_filename)
#       copy_file filename, new_filename
#     end
#   end
end
