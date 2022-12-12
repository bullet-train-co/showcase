require "test_helper"

class Showcase::PagesControllerTest < Showcase::IntegrationTest
  test "should get index" do
    get root_url

    assert_response :success
    assert_select "details summary", "Pages"
    assert_select %(details a[href="/docs/showcase/pages/button"]),   "Button"
    assert_select %(details a[href="/docs/showcase/pages/combobox"]), "Combobox"

    assert_select "details summary", "Stimulus Controllers"
    assert_select %(details a[href="/docs/showcase/pages/stimulus_controllers/welcome"]), "Welcome"
  end

  test "should get show" do
    get page_url("button")

    assert_response :success
    assert_select %(button[class~="text-sm"]), text: "Button content"
    assert_select %(button[class~="text-xl"]), text: "Button content"

    assert_select "table tr td pre", text: "The content to output as the button text"
    assert_select "table tr td pre", text: "content"
  end

  test "get nested component" do
    get page_url("combobox")

    assert_response :success
    assert_select "table", count: 0
  end

  test "rendering stimulus controller" do
    get page_url("stimulus_controllers/welcome")

    assert_response :success
    assert_select %(div[data-controller="welcome"]), count: 3
    assert_select %(div[data-controller="welcome"][data-welcome-yell-value])
    assert_select %(div[data-controller="welcome"] div[data-welcome-target="greeter"])
  end
end
