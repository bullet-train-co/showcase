require "test_helper"

class Showcase::EngineControllerTest < Showcase::InternalIntegrationTest
  test "#index renders Welcome content" do
    get showcase_path

    assert_response :ok
    assert_title "Showcase"
    within :main, "Showcase" do
      within :article, "Welcome to Showcase — your UI Pattern Library" do
        assert_section "What is this thing?"
        assert_section "How do I use it?"
        assert_section "But I don't see the thing I need"
        assert_section "I have questions, who do I reach out to?"
        assert_section "Additional resources"
      end
    end
  end

  test "#index renders navigation" do
    get showcase_path

    assert_response :ok
    within :navigation do
      assert_link "Showcase", href: root_url

      within :disclosure, "Templates", expanded: true do
        assert_link "Button", href: page_path("button")
        assert_link "Combobox", href: page_path("combobox")
      end
      within :disclosure, "Stimulus Controllers", expanded: true do
        assert_link "Welcome", href: page_path("stimulus_controllers/welcome")
      end
    end
  end
end
