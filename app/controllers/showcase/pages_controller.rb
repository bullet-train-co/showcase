class Showcase::PagesController < Showcase::ApplicationController
  def index
  end

  def show
    @preview = Showcase::Preview.find params[:id]
  end
end
