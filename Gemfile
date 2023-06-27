source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in showcase.gemspec.
gemspec

gem "sqlite3"

rails_version = ENV.fetch("RAILS_VERSION", "7.0")

rails_constraint = if rails_version == "main"
  {github: "rails/rails"}
else
  "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

gem "puma"

gem "rouge", require: false

group :test do
  gem "action_dispatch-testing-integration-capybara",
    github: "thoughtbot/action_dispatch-testing-integration-capybara", tag: "v0.1.1",
    require: "action_dispatch/testing/integration/capybara/minitest"
  gem "capybara_accessible_selectors",
    github: "citizensadvice/capybara_accessible_selectors", tag: "v0.10.0"
end
