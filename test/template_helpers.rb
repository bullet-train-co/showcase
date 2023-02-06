module TemplateHelpers
  def setup
    super
    @temporary_view_path = Pathname.new(Dir.mktmpdir).join("app", "views")
    @view_paths = ActionController::Base.view_paths

    ActionController::Base.prepend_view_path(@temporary_view_path)
  end

  def teardown
    super
    ActionController::Base.view_paths = @view_paths
  end

  def template_file(partial, html)
    @temporary_view_path.join(partial).tap do |file|
      file.dirname.mkpath

      file.write(html)
    end
  end
end
