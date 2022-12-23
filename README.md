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
