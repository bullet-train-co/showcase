class Showcase::PagesController < Showcase::ApplicationController
  def index
  end

  def show
    @showcase = Showcase::Display.find params[:id]
  end
end
