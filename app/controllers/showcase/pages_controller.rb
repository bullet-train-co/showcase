class Showcase::PagesController < Showcase::EngineController
  def index
  end

  def show
    @page = Showcase::Path.new(params[:id]).page_for view_context
  end
end
