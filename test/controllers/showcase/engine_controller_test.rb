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

      within :disclosure, "Previews", expanded: true do
        assert_link "Button", href: preview_path("button")
        assert_link "Combobox", href: preview_path("combobox")
      end
      within :disclosure, "Stimulus Controllers", expanded: true do
        assert_link "Welcome", href: preview_path("stimulus_controllers/welcome")
      end
    end
  end

  test "#index template can be overridden" do
    template_file "showcase/engine/index.html.erb", <<~HTML
      <section aria-labelledby="title">
        <h2 id="title">A Custom Welcome</h2>
      </section>
    HTML

    get showcase_path

    assert_response :ok
    within :main, "Showcase" do
      assert_region "A Custom Welcome"
    end
  end
end
