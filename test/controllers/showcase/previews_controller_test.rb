require "test_helper"

class Showcase::PreviewsControllerTest < Showcase::IntegrationTest
  test "#show renders samples and options" do
    get preview_path("button")

    assert_response :ok
    within :section, "Samples" do |section|
      section.find_css("[data-shadowroot]") do
        assert_button "Button content", class: %w[sc-text-xs]
        assert_button "Button content", class: %w[sc-text-xl]
      end
    end

    within :section, "Options" do
      assert_table with_rows: [
        {"Name" => "content", "Required" => "", "Type" => "String", "Default" => "", "Description" => "The content to output as the button text", "Options" => ""},
        {"Name" => "mode", "Required" => "", "Type" => "Symbol", "Default" => ":small", "Description" => "We support three modes", "Options" => "[:small, :medium, :large]"}
      ]
    end
  end

  test "#show does not render a <table>" do
    get preview_path("combobox")

    assert_response :ok
    assert_no_section "Options"
    assert_no_table
  end

  test "#show renders a title and description" do
    get preview_path("stimulus_controllers/welcome")

    assert_response :ok
    assert_section "Welcome", text: "The welcome controller says hello when it enters the screen"
  end

  test "#show renders samples" do
    get preview_path("stimulus_controllers/welcome")

    within :section, "Samples" do |section|
      section.find_css "[data-shadowroot]" do
        assert_region "Basic", text: "I've just said welcome!"
        within :region, "With greeter" do
          within :element, data: {controller: "welcome"} do
            assert_element text: "Somebody", data: {welcome_target: "greeter"}
          end
        end
  
        within :region, "Yelling!!!" do
          assert_element data: {controller: "welcome", welcome_yell_value: "true"}
        end
      end
    end
  end

  test "#show reads samples from partials in app/views/showcase/previews/" do
    name = SecureRandom.uuid

    template_file "showcase/previews/_test_local_sample.html.erb", <<~HTML
      <% showcase.sample "#{name}" do %>
        A new sample: #{name}
      <% end %>
    HTML

    get preview_path("test_local_sample")

    within :navigation do
      assert_link "Test Local Sample", href: preview_path("test_local_sample")
    end
    within :section, "Samples" do
      assert_region name, text: "A new sample: #{name}"
    end
  end

  test "#show samples can access URL helpers for the main_app" do
    template_file "showcase/previews/_link.html.erb", <<~HTML
      <% showcase.sample "root" do %>
        <%= link_to "root", main_app_root_path %>
      <% end %>
    HTML

    get preview_path("link")

    within :section, "Samples" do |section|
      section.find_css "[data-shadowroot]" do
        assert_link "root", href: "/main_app_root"
      end
    end
  end

  test "#show renders Custom sample partials" do
    template_file "showcase/engine/_sample.html.erb", <<~HTML
      <turbo-frame id="<%= sample.id %>_frame">
        <%= sample.name %>
      </turbo-frame>
    HTML

    get preview_path("stimulus_controllers/welcome")

    within :section, "Samples" do
      assert_element "turbo-frame", text: "Basic"
      assert_element "turbo-frame", text: "With greeter"
      assert_element "turbo-frame", text: "Yelling!!!"
    end
  end

  test "#show renders options" do
    get preview_path("stimulus_controllers/welcome")

    within :section, "Options" do
      assert_table with_rows: [
        {"Name" => %(data-welcome-target="greeter"), "Required" => "", "Type" => "String", "Default" => "", "Description" => "If the id of the target element must be printed"},
        {"Name" => "data-welcome-yell-value", "Required" => "", "Type" => "Boolean", "Default" => "false", "Description" => "Whether the hello is to be YELLED"},
        {"Name" => "data-welcome-success-class", "Required" => "", "Type" => "String", "Default" => "", "Description" => "The success class to append after greeting"},
        {"Name" => "data-welcome-list-outlet", "Required" => "", "Type" => "String", "Default" => "", "Description" => "An outlet to append each yelled greeter to"},
        {"Name" => %(data-action="greet"), "Required" => "", "Type" => "String", "Default" => "", "Description" => "An action to repeat the greeting, if need be"},
        {"Name" => "body", "Required" => "", "Type" => "Content Block", "Default" => "", "Description" => "An optional content block to set the body" }
      ]

      assert_checked_field type: "checkbox", disabled: true, count: 3
    end
  end
end
