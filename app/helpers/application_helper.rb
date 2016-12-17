
module ApplicationHelper
	
	def markdown text
		 markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       no_intra_emphasis: true,
                                       fenced_code_blocks: true,
                                       disable_indented_code_blocks: true,
                                       autolink: true,
                                       tables: true,
                                       underline: true,
                                       highlight: true
                                      )
    	return markdown.render(text).html_safe
	end

  def participants_text(cnt)
    cnt > 1 ? "#{cnt} participants" : "No other participant"
  end

  def asset_url_h(asset)
      "#{configatron.base_url}#{asset_path(asset)}"
  end

  def on_click_js_event(popup_selector)
    if !mobile_device?
      raw("$('#{popup_selector}').show(500); return false;")
    else
      "return true;"
    end
  end
	   
end