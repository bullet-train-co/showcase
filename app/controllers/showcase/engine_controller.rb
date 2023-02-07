class Showcase::EngineController < ActionController::Base
  layout "showcase"

  after_action { $view_context = view_context }

  helper Showcase::RouteHelper

  if defined?(::ApplicationController)
    helper all_helpers_from_path ::ApplicationController.helpers_path
  end

  def index
  end
end
