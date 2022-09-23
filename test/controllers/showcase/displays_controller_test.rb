require "test_helper"

class Showcase::DisplaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get showcase_root_url

    assert_response :success
    assert_select "details summary", html: %(<a href="/showcase/displays/components/button">button</a>)
  end

  test "should get show" do
    get showcase_display_url("components/button")

    assert_response :success
    assert_select %(button[class="text-sm"]), text: "Button content"
    assert_select %(button[class="text-xl"]), text: "Button content"

    assert_select "table tr td", text: "The content to output as the button text"
    assert_select "table tr td", text: ":content"
  end

  test "get nested component" do
    get showcase_display_url("components/combobox")

    assert_response :success
    assert_select "table", count: 0
  end

  test "rendering stimulus controller" do
    get showcase_display_url("stimulus_controllers/welcome")

    assert_response :success
    assert_select %(div[data-controller="welcome"]), count: 3
    assert_select %(div[data-controller="welcome"][data-welcome-yell-value])
    assert_select %(div[data-controller="welcome"] div[data-welcome-target="greeter"])
  end
end
