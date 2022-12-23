# Showcase

Showcase lets you build previews for your partials, components, view helpers, Stimulus controllers and more.

Add a template to `app/views/showcase/pages/templates` and it'll show up in Showcase's menu.

Here's how to showcase a standard button component:

```erb
<%# app/views/showcase/pages/templates/button.html.erb %>
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

## View examples

Clone the repository, run `bundle install`, then run `bin/rails server`, visit localhost:3000 in your browser.

## Overriding Showcase's default rendering

Showcase's rendering happens through the [`Showcase::PagesController`](blob/main/app/controllers/showcase/pages_controller.rb) with either the root url `index` or `show`.

All paths shown here are assumed to be in `app/views`.

The actions all use a `layout "showcase"`, which renders like this:

- layouts/showcase.html.erb
  - showcase/_root.html.erb
    - showcase/path/_tree.html.erb

So for `Showcase::PagesController#index` we render:

- showcase/pages/index.html.erb

And for `Showcase::PagesController#show` we render:

- showcase/pages/show.html.erb
  - showcase/pages/_page.html.erb
    - showcase/pages/_sample.html.erb
    - showcase/pages/_options.html.erb

If you want to override any specific rendering, e.g. how a `Showcase::Page` is rendered,
copy the file from our repo `app/views` directory into your `app/views` directory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "showcase"
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
