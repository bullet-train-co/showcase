class Showcase::DisplaysController < Showcase::ApplicationController
  def index
  end

  def show
    @showcase = Showcase::Displaycase[params[:displaycase_id]].find params[:id]
  end
end
