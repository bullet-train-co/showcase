require "test_helper"

class Viewtale::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get viewtale_pages_index_url
    assert_response :success
  end

  test "should get show" do
    get viewtale_pages_show_url
    assert_response :success
  end
end
