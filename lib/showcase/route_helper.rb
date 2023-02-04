module Showcase::RouteHelper
  def method_missing(name, ...)
    case name
    when /_path\Z/, /_url\Z/ then main_app.public_send(name, ...)
    else                          super
    end
  end
end
