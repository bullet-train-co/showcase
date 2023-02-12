class Showcase::PreviewsController < Showcase::EngineController
  def show
    @preview = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
