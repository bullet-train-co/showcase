module CapybaraExtensions::Assertions
  %i[element disclosure link region section table_row].each do |selector|
    class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def assert_#{selector}(...)
        assert_selector(#{selector.inspect}, ...)
      end

      def assert_no_#{selector}(...)
        assert_no_selector(#{selector.inspect}, ...)
      end
    RUBY
  end
end

Capybara::Node::Matchers.include CapybaraExtensions::Assertions
Capybara::Node::Simple.include CapybaraExtensions::Assertions if RUBY_VERSION < "3.0"

ActiveSupport.on_load :action_dispatch_integration_test do
  include CapybaraExtensions::Assertions
end

ActiveSupport.on_load :action_view_test_case do
  include Capybara::Minitest::Assertions
  include CapybaraExtensions::Assertions

  def page
    @page ||= Capybara.string(rendered.to_s)
  end
end
