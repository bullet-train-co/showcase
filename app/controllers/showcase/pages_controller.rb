class Showcase::PagesController < Showcase::ApplicationController
  def index
  end

  def show
    @page = Showcase::Path.new(params[:engine_id], params[:id]).page_for view_context
  end
end
