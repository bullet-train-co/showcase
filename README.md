# Showcase

Showcase lets you build previews for partials, components, view helpers and Stimulus controllers.

Add a view template to `app/views/showcases` and it'll show up in Showcase's menu.

Here's how to showcase a standard button component:

```erb
<%# app/views/showcases/button.html.erb %>
<% showcase.description "This button component handles what we click on" %>

<% showcase.sample "Basic" do %>
  <%= render "component/button", content: "Button content", mode: :small %>
<% end %>

<% showcase.sample "Large" do %>
  <%= render "component/button", content: "Button content", mode: :large %>
<% end %>

<% showcase.options do |o| %>
  <% o.required :content, String, "The content to output as the button text" %>
  <% o.optional :mode, default: :small, values: %i[ small medium large ], description: "We support three modes" %>
<% end %>
```

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
