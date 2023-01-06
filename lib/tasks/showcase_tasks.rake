# namespace :showcase do
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
# end
