class PushNotification

	CONFIG = YAML.load_file(Rails.root.join("config/gcm.yml"))[Rails.env]
	def self.send_post_chat_notifications(chat)
        gcm = GCM.new(CONFIG["api_key"])
		chat.chatable.members.each do |mem|
			next if mem == chat.user || mem.is_online?(chat.chatable)
			tokens = mem.device_tokens.map{|t| t.token}
			if !tokens.blank?
				gcm.send(tokens, {:data => {:message => chat.notify_text, 
					:redirect_url => Rails.application.routes.url_helpers.post_chats_path(chat.chatable, :auth_key => mem.user_auth_key, :uid => mem.id)}})
				Rails.logger.info "gcm log: notification sent to #{mem.name}(#{mem.id}) with #{tokens.length} devices"
			end
		end
	end
end