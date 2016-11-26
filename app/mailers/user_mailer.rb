class UserMailer < ApplicationMailer
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
end
