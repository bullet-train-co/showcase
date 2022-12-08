class Showcase::DisplaysController < Showcase::ApplicationController
  def index
  end

  def show
    @showcase = Showcase::Display.new(view_context, title: params[:id].split("/").last.titleize)
  end
end
