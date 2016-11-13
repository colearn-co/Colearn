
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
	   
end