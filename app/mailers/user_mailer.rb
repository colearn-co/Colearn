class UserMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	def join_request_mail(to, from, post)      
		@post = post
		@to = to
		@from = from
		mail(to: to.email, subject: "#{from.name} wants to join you")
    end

    def join_confirmation_mail(to, post)      
		@post = post
		@to = to
		mail(to: to.email, subject: "Colearn join confirmation")
    end

    def join_rejection_mail(invite)      
		@post = invite.post
		@to = invite.user
		@invite = invite
		mail(to: @to.email, subject: "Colearn - Post join request rejected")
    end

    def welcome_mail(to)
    	@to = to 
    	mail(to: to.email, subject: "Welcome to Colearn #{to.name}!")
    end

    def confirmation_mail(to)
        @user = to
        mail(to: @user.email, subject: "Confirmation instructions")
    end

    def post_chat_followup(user, post)
    	@user = user
    	@post = post
    	mail(to: @user.email, subject: "[Colearn] New chat messages from learning post " + post.title)
    end

    def posts_summary(user, posts) 
    	@user = user
    	@posts = posts
    	mail(to: @user.email, subject: "[Colearn] New learning requests")
    end
    
end
