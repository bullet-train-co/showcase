class Showcase::EngineController < ActionController::Base
  layout "showcase"

  helper Showcase::RouteHelper

  if defined?(::ApplicationController)
    helper all_helpers_from_path ::ApplicationController.helpers_path
  end

  def index
  end
end
