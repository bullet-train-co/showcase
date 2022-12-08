class Showcase::DisplaysController < Showcase::ApplicationController
  def index
  end

  def show
    @showcase = Showcase::Section.new(view_context, params[:section_id]).find params[:id]
  end
end
