
module ApplicationHelper
	
	def markdown text
		 markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true),
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

  def on_click_js_event(popup_selector) #TODO: rename this?
    if !mobile_device?
      raw("$('#{popup_selector}').toggle(500, function(){popup_toggle_callback('#{popup_selector}')}); return false;")
    else
      "return true;"
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def time_zone_diff_text(from, to)
    return "" if from.nil?
    diff = from.time_zone_diff_in_hours(to)
    if diff.nil?
      nil
    elsif diff == 0
      "(In your timezone)"
    elsif diff > 0
      "(#{diff.abs} hours ahead of you)"
    elsif diff < 0
      "(#{diff.abs} hours behind you)"
    else
      nil
    end
  end

  def signed_float(val, dec = 0)
    "#{val >= 0 ? '+' : ''}#{val.round(dec)}"
  end
	   
end