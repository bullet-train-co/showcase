# Showcase

Showcase lets you build previews for your partials, components, view helpers, Stimulus controllers and more.

Add a template to `app/views/showcase/previews` and it'll show up in Showcase's menu.

Here's how to showcase a standard button component:

```erb
<%# app/views/showcase/previews/_button.html.erb %>
<% showcase.title "Button" %> <%# `title` is optional and inferred from the filename, by default. %>
<% showcase.description "This button component handles what we click on" %>

<% showcase.sample "Basic" do %>
  <%= render "component/button", content: "Button content", mode: :small %>
<% end %>

<% showcase.sample "Large" do %>
  <%= render "component/button", content: "Button content", mode: :large %>
<% end %>

<% showcase.options do |o| %>
  <% o.required :content, "The content to output as the button text" %>
  <% o.optional :mode, "We support three modes", default: :small, options: %i[ small medium large ] %>
<% end %>
```

Which will then render the following:

![](/readme/example.png?raw=true "Showcase showing a button component")

## Using options contexts

Showcase also supports custom options contexts. They're useful for cases where the options have a very specific format and it would be nice to keep them standardized.

By default, Showcase ships Nice Partials and Stimulus contexts out of the box. Here's a sample of the Stimulus one:

```erb
<% showcase.options.stimulus controller: :welcome do |o| %>
  <% o.optional.targets :greeter, "If the id of the target element must be printed" %>
<% end %>
```

In case Showcase didn't ship with a Stimulus context, here's how you could add it:

```ruby
# config/initializers/showcase.rb
if defined?(Showcase)
  Showcase.options.define :stimulus do
    def targets(name, ...)
      option(%(data-#{@controller}-target="#{name}"), ...)
    end
  end
end
```

## Automatic previews testing

Showcase can automatically generate tests for all your Showcases to have it executed in your CI setup, run `bin/rails showcase:install:previews_test` to set this up.

 You can then open `test/views/showcase_test.rb` and add your own `setup` and `teardown` hooks, as well as override the provided `assert_showcase_preview` to add custom assertions.

If you need custom assertions for specific previews and their samples, you can use the `test` helper:

```ruby
# test/views/showcase_test.rb
require "test_helper"

class ShowcaseTest < Showcase::PreviewsTest
  test showcase: "combobox" do
    # This test block runs within the #combobox container element.
    assert_text "This is a combobox, for sure."
  end

  test showcase: "button", id: "basic" do
    # This test block runs within the #button container element's #basic sample.
    assert_button class: ["text-xs"]
  end

  test "some non-Showcase test" do
    # You can still use the regular Rails `test` method too.
  end
end
```

## View examples

Clone the repository, run `bundle install`, then run `bin/rails server`, visit localhost:3000 in your browser.

## Overriding Showcase's default rendering

Showcase's rendering happens through two controllers:

1. [`Showcase::EngineController`](app/controllers/showcase/engine_controller.rb)
1. [`Showcase::PreviewsController`](app/controllers/showcase/previews_controller.rb)

All paths shown here are assumed to be in `app/views`.

The actions all use a `layout "showcase"`, which renders like this:

- [layouts/showcase.html.erb](app/views/layouts/showcase.html.erb)
  - [showcase/engine/_root.html.erb](app/views/showcase/engine/_root.html.erb)
    - [showcase/engine/path/_tree.html.erb](app/views/showcase/engine/path/_tree.html.erb)

So for `Showcase::EngineController#index` we render:

- [showcase/engine/index.html.erb](app/views/showcase/engine/index.html.erb)

And for `Showcase::PreviewsController#show` we render:

- [showcase/engine/show.html.erb](app/views/showcase/engine/show.html.erb)
  - [showcase/engine/_preview.html.erb](app/views/showcase/engine/_preview.html.erb)
    - [showcase/engine/_sample.html.erb](app/views/showcase/engine/_sample.html.erb)
    - [showcase/engine/_options.html.erb](app/views/showcase/engine/_options.html.erb)

If you want to override any specific rendering, e.g. how a `Showcase::Preview` is rendered,
copy the file from our repo `app/views` directory into your `app/views` directory.

### Loading your own assets

Showcase bundles its own `showcase.js`, `showcase.css` and `showcase.highlights.css` asset files through
Action View's [javascript_include_tag][] and [stylesheet_link_tag][].

If your assets require more sophisticated loading techniques, declare your own
versions of the [showcase/engine/_javascripts.html.erb][] and
[showcase/engine/_stylesheets.html.erb][] partials. When customizing those
partials, make sure to include `"showcase"` in your list of assets.

[javascript_include_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-javascript_include_tag
[stylesheet_link_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag
[showcase/engine/_javascripts.html.erb]: ./showcase/engine/_javascripts.html.erb
[showcase/engine/_stylesheets.html.erb]: ./showcase/engine/_stylesheets.html.erb

#### Loading your own syntax highlighting theme

By default, Showcase's syntax highlighting runs on Rouge's "github" theme.

To use a different theme, override [showcase/engine/_stylesheets.html.erb][] with the following, replacing `:magritte` with a [valid theme](rouge-themes):

```erb
<%= stylesheet_link_tag "application", "showcase" %> # We've removed the default showcase.highlights file here.
<%= tag.style Rouge::Theme.find(:magritte).render(scope: ".sc-highlight") %>
```

[rouge-themes]: https://github.com/rouge-ruby/rouge/tree/master/lib/rouge/themes

## Installation

Add this line to your application's Gemfile. To get the automatic integration testing make sure the `showcase-rails` gem is available to your test environment:

```ruby
group :development, :test do
  gem "showcase-rails"
end
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install showcase-rails
```

Then add the following in your `config/routes.rb` within the block passed to `Rails.application.routes.draw`:

```ruby
mount Showcase::Engine, at: "/docs/showcase" if defined?(Showcase::Engine)
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
