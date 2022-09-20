class Viewtale::PagesController < Viewtale::ApplicationController
  def index
  end

  def show
    @preview = Viewtale::Preview.find params[:id]
  end
end
