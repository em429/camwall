module CamsHelper
  def on_wide_page?
    true if current_page?(root_path) || current_page?(favorite_cams_path)
  end
end
