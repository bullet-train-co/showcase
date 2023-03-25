# frozen_string_literal: true

module Showcase::RouteHelper
  def method_missing(name, ...)
    if name.end_with?("_path", "_url")
      main_app.public_send(name, ...)
    else
      super
    end
  end
end
