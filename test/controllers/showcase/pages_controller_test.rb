require "test_helper"

class Showcase::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get showcase_root_url

    assert_response :success
    assert_select "details summary", html: %(<a href="/showcase/pages/button">button</a>)
  end

  test "should get show" do
    get showcase_page_url("button")

    assert_response :success
    assert_select %(button[class="text-sm"]), text: "Button content"
    assert_select %(button[class="text-xl"]), text: "Button content"
  end
end
