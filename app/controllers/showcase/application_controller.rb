class Showcase::ApplicationController < ActionController::Base
  layout "showcase"

  if defined?(::ApplicationController)
    helper all_helpers_from_path ::ApplicationController.helpers_path
  end
end
