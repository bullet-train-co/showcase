module Showcase::LinkHelper
  def link_to_showcase(name, id: nil)
    link_to preview_path(name, anchor: id), class: "sc-font-mono sc-text-sm" do
      "<#{[name, id].compact.join("#").squish}>"
    end
  end
end
