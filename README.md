# Viewtale

Viewtale lets you build previews for partials, components, view helpers and Stimulus controllers.

Add a view template to `app/views/tales` and it'll show up in Viewtale's menu.

Here's how to showcase a standard button component:

```erb
<%# app/views/tales/button.html.erb %>
<% viewtale.title "Our Button element" %>
<% viewtale.description "This button component handles what we click on" %>

<% viewtale.example do %>
  <%= render "component/button", content: "Button content", mode: :small %>
<% end %>

<% viewtale.example "Large" do %>
  <%= render "component/button", content: "Button content", mode: :large %>
<% end %>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "viewtale"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install viewtale
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
