require "test_helper"

class Showcase::PagesControllerTest < Showcase::IntegrationTest
  test "#show renders samples and options" do
    get page_path("button")

    assert_response :ok
    within :section, "Samples" do
      assert_button "Button content", class: %w[text-xs]
      assert_button "Button content", class: %w[text-xl]
    end

    within :section, "Options" do
      assert_table with_rows: [
        {"Name" => "content", "Required" => "", "Type" => "String", "Default" => "", "Description" => "The content to output as the button text", "Options" => ""},
        {"Name" => "mode", "Required" => "", "Type" => "Symbol", "Default" => ":small", "Description" => "We support three modes", "Options" => "[:small, :medium, :large]"}
      ]
    end
  end

  test "#show does not render a <table>" do
    get page_path("combobox")

    assert_response :ok
    assert_no_section "Options"
    assert_no_table
  end

  test "#show renders a title and description" do
    get page_path("stimulus_controllers/welcome")

    assert_response :ok
    assert_section "Welcome", text: "The welcome controller says hello when it enters the screen"
  end

  test "#show renders samples" do
    get page_path("stimulus_controllers/welcome")

    within :section, "Samples" do
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

  test "#show renders options" do
    get page_path("stimulus_controllers/welcome")

    within :section, "Options" do
      assert_table with_rows: [
        {"Name" => "data-welcome-target", "Required" => "", "Type" => "String", "Default" => "", "Description" => "If the id of the target element must be printed"},
        {"Name" => "data-welcome-yell-value", "Required" => "", "Type" => "Boolean", "Default" => "false", "Description" => "Whether the hello is to be YELLED"}
      ]
    end
  end
end
