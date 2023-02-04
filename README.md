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

## Automatic smokescreen testing

Run `bin/rails showcase:install:integration_test` to automatic testing installed in `test/integration/showcase_test.rb`.

This will render every Showcase you've defined and assert they respond with `200 OK`. You can add custom assertions by overriding `assert_showcase_preview`.

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

Showcase bundles its own `showcase.js` and `showcase.css` asset files through
Action View's [javascript_include_tag][] and [stylesheet_link_tag][].

If your assets require more sophisticated loading techniques, declare your own
versions of the [showcase/engine/_javascripts.html.erb][] and
[showcase/engine/_stylesheets.html.erb][] partials. When customizing those
partials, make sure to include `"showcase"` in your list of assets.


[javascript_include_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-javascript_include_tag
[stylesheet_link_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag
[showcase/engine/_javascripts.html.erb]: ./showcase/engine/_javascripts.html.erb
[showcase/engine/_stylesheets.html.erb]: ./showcase/engine/_stylesheets.html.erb

## Installation

Add this line to your application's Gemfile. If you're utilizing the
[Showcase::IntegrationTest](lib/showcase/integration_test.rb) class, make sure
that the `showcase-rails` gems is available to your test environment:


```ruby
# nested in the default group
gem "showcase-rails"

# or nested in the :development and :test groups
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
$ gem install showcase
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
