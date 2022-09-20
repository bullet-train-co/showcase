class Viewtale::PagesController < Viewtale::ApplicationController
  def index
  end

  def show
    @preview = Viewtale::Preview.find params[:id]
  rescue Errno::ENOENT
    # TODO: decide on how to handle a missing preview.
  end
end
