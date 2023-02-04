class Showcase::PagesController < Showcase::EngineController
  def index
  end

  def show
    @page = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
