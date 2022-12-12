class Showcase::PagesController < Showcase::ApplicationController
  def index
  end

  def show
    @page = Showcase::Path.new(params[:id]).page_for view_context
  end
end
