require "test_helper"

class Viewtale::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get viewtale_pages_url

    assert_response :success
    assert_select "details", text: "button.html.erb"
  end
end
