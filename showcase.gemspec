require_relative "lib/showcase/version"

Gem::Specification.new do |spec|
  spec.name        = "showcase-rails"
  spec.version     = Showcase::VERSION
  spec.authors     = ["Daniel Pence", "Kasper Timm Hansen"]
  spec.email       = ["hey@kaspth.com"]
  spec.homepage    = "https://github.com/kaspth/showcase"
  spec.summary     = "Showcase helps you show off and document your partials, components, view helpers and Stimulus controllers."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.1.0"
  spec.add_dependency "brb-templates", ">= 0.1.1"
  spec.add_development_dependency "tailwindcss-rails"
end
