class BotObservation < ActiveRecord::Observer
	 include Rails.application.routes.url_helpers
	observe :post, :suggestion, :invite

	def after_create(record)
		if record.class == Post
			msg = "Hi there #{record.user.username} :joy: . Your learning post (#{post_url(record)}) is created successfully  :book:\n" + "I am default member of all chats :stuck_out_tongue_winking_eye:\n" + "Cheers. :thumbsup: :thumbsup: :thumbsup:"
			record.create_user_chat(User.colearn_bot, ActionController::Parameters.new(chat: {:message => msg}))
		elsif record.class == Suggestion
			msg = "#{record.user.username} suggested: \r\n
				#{record.message}"
			record.post.create_user_chat(User.colearn_bot, ActionController::Parameters.new(chat: {:message => msg}))			
		end
	end

	def after_update(record)
		if record.class == Invite
			if record.status_changed? && record.is_accepted?
				msg = "Welcome #{record.user.username} :sunglasses::sunglasses::sunglasses:"
				record.post.create_user_chat(User.colearn_bot, ActionController::Parameters.new(chat: {:message => msg}))				
			end			
		end
	end
end

