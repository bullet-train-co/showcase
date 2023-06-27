# Showcase

Showcase lets you build previews for your partials, components, view helpers, Stimulus controllers and more — Rails engines included!

Add a partial to `app/views/showcase/previews` and it'll show up in Showcase's menu.

| Light Mode | Dark Mode |
| --- | --- |
| ![](/readme/example-light.png?raw=true "Showcase showing a button component") | ![](/readme/example-dark.png?raw=true "Showcase showing a button component") |

Each sample shows the render time in milliseconds and the allocation count so it's easier to spot if there's something different happening between your samples.

## What can I showcase?

### Rails partials

Here's how to showcase a standard button component written with standard Rails partials:

```erb
<%# app/views/showcase/previews/components/_button.html.erb %>
<% showcase.title "Button" %> <%# `title` is optional and inferred from the filename, by default. %>
<% showcase.badge :partial, :component %> <%# Optional badges you can add to further clarify the type of the showcase. %>
<% showcase.description "This button component handles what we click on" %>

<% showcase.sample "Basic" do %>
  <%= render "components/button", content: "Button content", mode: :small %>
<% end %>

<% showcase.sample "Large", description: "This is our larger button" do %>
  <%= render "components/button", content: "Button content", mode: :large %>
<% end %>

<% showcase.options do |o| %>
  <% o.required :content, "The content to output as the button text" %>
  <% o.optional :mode, "We support three modes", default: :small, options: %i[ small medium large ] %>
<% end %>
```

### Components with ViewComponent

If we take the `MessageComponent` as seen on [https://viewcomponent.org](https://viewcomponent.org):

```ruby
# app/components/message_component.rb
class MessageComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end
end
```

```erb
<%# app/components/message_component.html.erb %>
<h1>Hello, <%= @name %>!</h1>
```

We can showcase it just by rendering it:

```erb
<%# app/views/showcase/previews/components/_message_component.html.erb %>
<% showcase.sample "Basic" do %>
  <%= render MessageComponent.new(name: "World") %>
<% end %>

<% showcase.options do |o| %>
  <% o.required :name, "The name to say hello to" %>
<% end %>
```

### Components with Phlex

Given this [phlex-rails](https://www.phlex.fun/rails/) component:

```ruby
# app/views/components/article.rb
class Components::Article < Phlex::HTML
  def initialize(article) = @article = article

  def template
    h1 { @article.title }
  end
end
```

We can use Rails' `render` method to showcase it:

```erb
<%# app/views/showcase/previews/components/_article.html.erb %>
<% showcase.sample "Basic" do %>
  <%= render Components::Article.new(Article.first) %>
<% end %>
```

### View helpers

Any application helpers defined in `app/helpers` are automatically available in Showcase's engine, so given a helper like this:

```ruby
# app/helpers/upcase_helper.rb
module UpcaseHelper
  def upcase_string(string)
    string.upcase
  end
end
```

You can showcase it like this:

```erb
<%# app/views/showcase/previews/helpers/_upcase_helper.html.erb %>
<% showcase.sample "Basic" do %>
  <%= upcase_string "hello" %>
<% end %>
```

### JavaScript with Stimulus controllers

Assuming we have a Stimulus controller like this:

```javascript
// app/assets/javascripts/controllers/welcome_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "greeter" ]
  static values = { yell: Boolean }

  connect() {
    let greeting = this.hasGreeterTarget ? `Welcome, ${this.greeterTarget.textContent}!` : "Welcome!"
    if (this.yellValue) greeting = greeting.toUpperCase()

    console.log(greeting)
    this.dispatch("greeting", { detail: { greeting } })
  }
})
```

We can then render it to showcase it:

```erb
<% showcase.description "The welcome controller says hello when it enters the screen" %>

<% showcase.sample "Basic", events: "welcome:greeting" do %>
  <div data-controller="welcome">I've just said welcome!</div>
<% end %>

<% showcase.sample "With greeter", events: "welcome:greeting" do %>
  <div data-controller="welcome">
    <div data-welcome-target="greeter">Somebody</div>
  </div>
<% end %>

<% showcase.sample "Yelling!!!", events: "welcome:greeting" do %>
  <div data-controller="welcome" data-welcome-yell-value="true">
<% end %>

<%# We're using the built-in Stimulus context here to output `data-` attributes correctly, and save some typing. %>
<% showcase.options.context :stimulus, controller: :welcome do |o| %>
  <% o.optional.targets :greeter, "If the id of the target element must be printed" %>
  <% o.required.values :yell, "Whether the hello is to be YELLED", default: false %>

  <%# We support the other Stimulus declarations too: %>
  <% o.required.classes :success, "The success class to append after greeting" %>
  <% o.required.outlet :list, "An outlet to append each yelled greeter to" %>
  <% o.optional.action :greet, "An action to repeat the greeting, if need be" %>
<% end %>
```

Note that by adding `events: "welcome:greeting"` we're listening for any time that event is dispatched. Events are logged with `console.log`, but also output alongside the sample in the browser.

## Installation

Add these lines to your application's Gemfile. See next section for why Showcase is in the test group.

```ruby
group :development, :test do
  gem "showcase-rails"
  gem "rouge", require: false # Syntax highlighting, `require: false` lets Showcase handle loading and saves boot time.
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

### Automatic previews testing

To have Showcase generate tests to exercise all your previews on CI, run `bin/rails showcase:install:previews_test` to add `test/views/showcase_test.rb`.

 There you can add `setup` and `teardown` hooks, plus override the provided `assert_showcase_preview` to add custom assertions for any preview.

If you need custom assertions for specific previews, you can use the `test` helper:

```ruby
# test/views/showcase_test.rb
require "test_helper"

class ShowcaseTest < Showcase::PreviewsTest
  test showcase: "combobox" do
    # This test block runs within the #combobox container element.
    assert_text "This is a combobox, for sure."
  end

  test showcase: "button" do
    assert_selector id: "basic" do
      assert_button class: ["text-xs"]
    end
  end

  test "some non-Showcase test" do
    # You can still use the regular Rails `test` method too.
  end
end
```

### Syntax Highlighting

Add `gem "rouge", require: false` to your Gemfile and Showcase will set syntax highlighting up for you. Any denoted syntaxes in your samples are then highlighted, e.g.:

```erb
# app/views/showcase/previews/_plain_ruby.ruby
<% showcase.sample "Basic", syntax: :ruby do %>
  concat "hello".upcase
<% end %>
```

By default, `syntax: :erb` is used, so you don't need to mark the majority of your samples.

#### Replacing the highlighter

To use a different syntax highlighter, assign your own Proc to `sample_renderer` like this:

```ruby
# config/initializers/showcase.rb
return unless defined?(Showcase)

Showcase.sample_renderer = ->(source, syntax) do
  # Return a String of lexed and formatted code.
end
```

#### Replacing the theme

By default, Showcase's syntax highlighting runs on Rouge's `"github"` theme.

To use a different theme, override [showcase/engine/_stylesheets.html.erb](app/views/showcase/engine/_stylesheets.html.erb) with the following, replacing `:magritte` with a [valid theme](rouge-themes):

```erb
<%= stylesheet_link_tag "showcase" %> <%# We've removed the default showcase.highlights file here. %>
<%= tag.style Rouge::Theme.find(:magritte).render(scope: ".sc-highlight") %>
```

[rouge-themes]: https://github.com/rouge-ruby/rouge/tree/master/lib/rouge/themes

## Taking Showcase further

### View examples

Clone the repository, run `bundle install`, then run `bin/rails server`, and visit localhost:3000 in your browser. You'll see the examples from [test/dummy/app/views/showcase/previews](test/dummy/app/views/showcase/previews).

### Configuring what trees to open

Showcase's sidebar mirrors your `app/views/showcase/previews` directory with their paths, and then trees at each directory level.

So a `showcase/previews` directory with `_top_level.html.erb`, `components/_button.html.erb`, `deeply/nested/_partial.html.erb`, will generate a sidebar like this:

- Previews
  - Top Level
- Components
  - Button
- Deeply
  - Nested
    - Partial

Internally, Showcase renders an open `details` element for each tree. You can control that with this:

```ruby
# config/initializers/showcase.rb
return unless defined?(Showcase)

Showcase.tree_opens = true  # All trees are open (the default).
Showcase.tree_opens = false # All trees are closed.
Showcase.tree_opens = ->(tree) { tree.root? } # Only open the root level trees (Previews, Components, Deeply but not Nested).
Showcase.tree_opens = ->(tree) { tree.id.start_with? ".", "components" } # Just open the top-level tree and the components tree.
```

### Linking to previews

Call `showcase.link_to` with the URL path to the other Showcase:

```erb
<%= showcase.link_to "stimulus_controllers/welcome" %>
<%= showcase.link_to "components/button", id: "extra-large" %> <%# Pass an id to link to a specific sample %>

<%# You can also pass just an id: to target a sample on the current showcase %>
<%= showcase.link_to id: "extra-large" %>
```

### Adding options contexts

Showcase also supports custom options contexts. They're useful for cases where the options have a very specific format and it would be nice to keep them standardized.

By default, Showcase ships Nice Partials and Stimulus contexts out of the box. See [lib/showcase.rb](lib/showcase.rb) for how they're defined.

To add a new context, you can do this:

```ruby
# config/initializers/showcase.rb
return unless defined?(Showcase)

Showcase.options.define :some_context do
  def targets(name, ...)
    option("data-#{@prefix}-#{name}", ...)
  end
end
```

And now we can use it, here passing in `prefix:` which becomes an instance variable available in the `define` block.

```erb
<% showcase.options.context :some_context, prefix: "super-" do |o| %>
  <% o.required.targets :title %>
<% end %>
```

### Full Rails engine support

Any Rails engines in your app that ships previews in their `app/views/showcase/previews` directory will automatically be surfaced in your app. Here's an example from the [bullet_train-themes-light Rails engine](https://github.com/bullet-train-co/bullet_train-core/tree/main/bullet_train-themes-light/app/views/showcase/previews).

Showcase respects the Rails views rendering order, allowing you to override a specific preview. So if an engine ships an `app/views/showcase/previews/partials/_alert.html.erb` preview, you can copy that to the same path in your app and tailor it to suit your app's documentation needs. Showcase will then show your override instead of the engine's original.

_📖 How does this work? 📖_ Internally, Showcase leverages Rails controllers' ordered set of `view_paths` — which each engine automatically prepends their app/views directory to by calling something like [`ActionController::Base.prepend_view_path`](https://github.com/rails/rails/blob/e78ed07e008676752b2ed2cff97e74b31ffacaf5/railties/lib/rails/engine.rb#L606) when initializing.

### Overriding Showcase's default rendering

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
version of the [showcase/engine/_head.html.erb][] partial.

If you need to tweak showcase's assets, declare your own versions of
the [showcase/engine/_javascripts.html.erb][] and
[showcase/engine/_stylesheets.html.erb][] partials. When customizing those
partials, make sure to include `"showcase"` in your list of assets.

[javascript_include_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-javascript_include_tag
[stylesheet_link_tag]: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag
[showcase/engine/_head.html.erb]: app/views/showcase/engine/_head.html.erb
[showcase/engine/_javascripts.html.erb]: app/views/showcase/engine/_javascripts.html.erb
[showcase/engine/_stylesheets.html.erb]: app/views/showcase/engine/_stylesheets.html.erb

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
