class Showcase::PreviewsController < Showcase::EngineController
  def index
  end

  def show
    @preview = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
