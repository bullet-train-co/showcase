require "test_helper"

class Showcase::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url

    assert_response :success
    assert_select "details summary", "Components"
    assert_select "details li", html: %(<a href="/showcase/pages/button">Button</a>)
    assert_select "details li", html: %(<a href="/showcase/pages/combobox">Combobox</a>)
    assert_select "details summary", "Stimulus controllers"
    assert_select "details li", html: %(<a href="/showcase/pages/stimulus_controllers/welcome">Welcome</a>)
  end

  test "should get show" do
    get page_url("button")

    assert_response :success
    assert_select %(button[class="text-sm"]), text: "Button content"
    assert_select %(button[class="text-xl"]), text: "Button content"

    assert_select "table tr td", text: "The content to output as the button text"
    assert_select "table tr td", text: ":content"
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
