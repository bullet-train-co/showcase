require "test_helper"

class Showcase::DisplaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get showcase_root_url

    assert_response :success
    assert_select "details summary", html: %(<a href="/showcase/displays/button">button</a>)
  end

  test "should get show" do
    get showcase_display_url("button")

    assert_response :success
    assert_select %(button[class="text-sm"]), text: "Button content"
    assert_select %(button[class="text-xl"]), text: "Button content"

    assert_select "table tr td", text: "The content to output as the button text"
    assert_select "table tr td", text: ":content"
  end
end
