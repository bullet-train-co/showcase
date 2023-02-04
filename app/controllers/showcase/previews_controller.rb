class Showcase::PreviewsController < Showcase::EngineController
  def local_prefixes
    ["showcase/engine"]
  end

  def index
  end

  def show
    @preview = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
