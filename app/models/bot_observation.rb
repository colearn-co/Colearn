class BotObservation < ActiveRecord::Observer
	observe :post, :suggestion, :invite

	def after_create(record)
		if record.class == Post
			msg = "Congratulations your learning post is created. You can now start chatting! \r\n 
				Share how you are going to start. This will help other members to sync up as soon as they join!"
			record.create_user_chat(User.colearn_bot, {:message => msg})
		elsif record.class == Suggestion
			msg = "#{record.user.name} suggested: \r\n
				#{record.message}"
			record.post.create_user_chat(User.colearn_bot, {:message => msg})			
		end
	end

	def after_update(record)
		if record.class == Invite
			if record.status_changed? && record.is_accepted?
				msg = "Please join me to welcome #{record.user.name}!"
				record.post.create_user_chat(User.colearn_bot, {:message => msg})				
			end			
		end
	end
end