class Showcase::PagesController < Showcase::ApplicationController
  def index
  end

  def show
    @path = Showcase::Path.new params[:id]
  end
end
