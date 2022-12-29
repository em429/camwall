module CamsHelper
  def on_wide_page?
    true if current_page?(root_path) || current_page?(favorite_cams_path)
  end

  # TODO: ISO3166::Country from 'countries' gem is not available here by default
  # How to include stuff in helpers from gems?
  def emoji_flag(country_code)
    ISO3166::Country.new([country_code]).emoji_flag
  end
end
