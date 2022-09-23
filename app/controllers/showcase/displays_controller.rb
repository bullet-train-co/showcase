class Showcase::DisplaysController < Showcase::ApplicationController
  def index
  end

  def show
    @showcase = Showcase::Displaycase.new(params[:displaycase_id]).find params[:id]
  end
end
