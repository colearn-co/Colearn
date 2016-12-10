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

    
end
