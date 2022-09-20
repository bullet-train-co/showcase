require "test_helper"

class Viewtale::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get viewtale_pages_url

    assert_response :success
    assert_select "details summary", html: %(<a href="/viewtale/pages/button.html.erb">button.html.erb</a>)
  end
end
