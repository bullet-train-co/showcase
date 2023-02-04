class Showcase::PreviewsController < Showcase::EngineController
  # Inserts engine into Rails' controller view lookup.
  # Ref: https://github.com/rails/rails/blob/4b560ab00c1de5ab763b1a0fbfad4d1ea8b60fe7/actionview/lib/action_view/view_paths.rb#L68
  class_attribute :local_prefixes, default: ["showcase/engine/previews"]

  def index
  end

  def show
    @preview = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
