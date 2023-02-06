Capybara::Selector.all.each_key do |selector|
  Capybara.modify_selector selector do
    # Accept a `data: {...}` filter that transforms nested keys in the same
    # style as Action View's `tag` builder:
    #
    #   https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag-label-Options
    #
    # Values are passed straight through to Capybara, and transformed
    # to XPath queries
    #
    #  # this assertion fails for
    #  # => <button data-controller="element another-controller"></button>
    #  assert_button "Hello", data: {controller: "element"}
    #
    #  # this assertion passes for
    #  # => <button data-controller="element another-controller"></button>
    #  assert_button "Hello", data: {controller: /element/}
    #
    expression_filter(:data, Hash, skip_if: nil) do |scope, nested_attributes|
      prefixed_attributes = nested_attributes.transform_keys { |key| "data-#{key.to_s.dasherize}" }

      case scope
      when String
        selectors = prefixed_attributes.map { |key, value| %([#{key}="#{value}"]) }

        [scope, *selectors].join
      else
        expressions = prefixed_attributes.map do |key, value|
          builder(XPath.self).add_attribute_conditions(key.to_sym => value)
        end

        scope[expressions.reduce(:&)]
      end
    end

    describe(:expression_filters) do |data: {}, **|
      attributes = data.map { |key, value| %(data-#{key.to_s.dasherize}="#{value}") }

      " with #{attributes.join(" and ")}" unless attributes.empty?
    end
  end
end
