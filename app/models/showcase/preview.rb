class Showcase::Preview
  attr_reader :id, :badges, :samples

  def initialize(view_context, id:, title: nil)
    @view_context, @id = view_context, id
    @badges, @samples = [], []
    title title
  end

  # Set a custom title for the Preview. By default, it's automatically inferred from the sidebar title,
  # e.g. showcase/previews/_button.html.erb will have Button as the title.
  def title(content = nil)
    @title = content if content
    @title
  end

  # Describe the Preview in more detail to help guide other developers on what the inner partial/component etc.'s purpose is.
  #
  #   <% showcase.description "Our button element" %>
  #   <% showcase.description do %>
  #      <h3>Our button element</h3> — <span>but with custom description HTML</span>
  #   <% end %>
  def description(content = nil, &block)
    @description = content || @view_context.capture(&block) if content || block_given?
    @description
  end

  # Optional badges you can give to a preview:
  #
  #   <% showcase.badge :partial, :view_helper %>
  def badge(*badges)
    @badges.concat badges
  end

  # Allows linking out to other Showcases
  #
  #   <%= showcase.link_to "components/button", id: "extra-large" %>
  #   # => <a href="components/button#extra-large"><showcase components/button#extra-large></a>
  #
  # Can link to other samples on the current showcase too:
  #
  #   # If we're within app/views/showcase/previews/components/_button.html.erb
  #   <%= showcase.link_to id: "extra-large" %>
  #   # => <a href="components/button#extra-large"><showcase components/button#extra-large></a>
  def link_to(preview_id = id, id: nil)
    @view_context.link_to Showcase::Engine.routes.url_helpers.preview_path(preview_id, anchor: id), class: "sc-link sc-font-mono sc-text-sm" do
      "<showcase #{[preview_id, id].compact.join("#").squish}>"
    end
  end

  # Adds a named sample to demonstrate with the Showcase can do.
  #
  # By default, sample takes a block that'll automatically have its source extracted, like this:
  #
  #   <% showcase.sample "Basic" do %>
  #     <%= render "components/button", content: "Button Content", mode: :small %>
  #   <% end %>
  #
  # This outputs a `<showcase-sample>` custom HTML element.
  # The sample name is used to generate the `id` via `name.parameterize` by default, pass `id:` to override.
  #
  # If more advanced rendering is needed, the sample is available as a block argument:
  #
  #   <% showcase.sample "Advanced" do |sample| %>
  #     <% sample.preview do %>
  #       <%= render "components/button", content: "Button Content", mode: :small %>
  #     <% end %>
  #
  #     <% sample.extract do %>
  #       This will be in the source output.
  #     <% end %>
  #
  # The sample also supports several extra options:
  #
  #   <% showcase.sample "Basic", id: "custom-id", description: "Please use this", events: "toggle:toggled", custom: "option" do %>
  #     <%# … %>
  #   <% end %>
  #
  # Here we set:
  #   - the `sample.id` with the HTML element `id` is overriden
  #   - the `sample.description`
  #   - the `sample.events` what JavaScript `events` to listen for on the element
  #   - any other custom options are available in `sample.details`.
  def sample(name, **options, &block)
    @samples << Showcase::Sample.new(@view_context, name, **options).tap { _1.evaluate(&block) }
  end

  # Yields an Options object to help define the configuration table for a Preview.
  #
  #   <% showcase.options do |o| %>
  #     <% o.required :content,    "Pass the inner content text that the button should display" %>
  #     <% o.optional :mode,       "Pass an optional mode override", default: :small, options: %i[ small medium large ] %>
  #     <% o.optional :method,     "What HTTP method to use", type: "String | Symbol", default: :post %>
  #     <% o.optional :reversed,   "Whether the inner text should be reversed", default: false %> # type: "Boolean" is inferred from the default here.
  #     <% o.optional "**options", "Every other option is passed on as options to the inner `button_tag`", type: Hash %>
  #   <% end %>
  #
  # The `type:` is derived if a `default:` is passed, otherwise it's assumed to be a String.
  #
  # Showcase outputs the columns with this order [:name, :required, :type, :default, :description], any other passed column is
  # automatically rendered after those.
  def options
    @options ||= Showcase::Options.new(@view_context).tap { yield _1 if block_given? }
  end

  def render_associated_partial
    @view_context.render "showcase/previews/#{id}", showcase: self
    nil
  end
end
