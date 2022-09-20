require_relative "lib/viewtale/version"

Gem::Specification.new do |spec|
  spec.name        = "viewtale"
  spec.version     = Viewtale::VERSION
  spec.authors     = ["Kasper Timm Hansen"]
  spec.email       = ["hey@kaspth.com"]
  spec.homepage    = "https://github.com/kaspth/viewtale"
  spec.summary     = "Viewtale lets you build previews for partials, components, view helpers and Stimulus controllers."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.3.1"
end
