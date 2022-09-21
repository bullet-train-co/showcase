require "test_helper"

class Viewtale::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get viewtale_root_url

    assert_response :success
    assert_select "details summary", html: %(<a href="/viewtale/pages/button">button</a>)
  end

  test "should get show" do
    get viewtale_page_url("button")

    assert_response :success
    assert_select %(button[class="text-sm"]), text: "Button content"
    assert_select %(button[class="text-xl"]), text: "Button content"
  end
end
