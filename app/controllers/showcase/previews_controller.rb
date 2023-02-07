class Showcase::PreviewsController < Showcase::EngineController
  singleton_class.attr_accessor :view_context
  after_action { self.class.view_context = view_context } if Rails.env.test?

  def show
    @preview = Showcase::Path.new(params[:id]).preview_for view_context
  end
end
