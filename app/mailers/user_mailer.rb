class UserMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	def join_request_mail(to, from, post)      
		@post = post
		@to = to
		@from = from
		mail(to: to.email, subject: "#{from.username} wants to join learning '#{post.title}'")
    end

    def join_confirmation_mail(to, post)      
		@post = post
		@to = to
		mail(to: to.email, subject: 'Colearn join confirmation')
    end

    def join_rejection_mail(invite)      
		@post = invite.post
		@to = invite.user
		@invite = invite
		mail(to: @to.email, subject: 'Colearn - Post join request rejected')
    end

    def welcome_mail(to)
    	@to = to 
    	mail(to: to.email, subject: "Welcome to Colearn #{to.username}!")
    end

    def confirmation_mail(to)
        @user = to
        mail(to: @user.email, subject: 'Confirmation instructions')
    end

    def post_chat_followup(user, post)
    	@user = user
    	@post = post
    	mail(to: @user.email, subject: '[Colearn] New chat messages from learning post ' + post.title)
    end

    def posts_summary(user, posts) 
    	@user = user
    	@posts = posts
    	mail(to: @user.email, subject: '[Colearn] New learning requests')
    end

    def download_app(user)
        @user = user
        mail(to: @user.email, subject: '[Colearn] Never miss an important message')
    end

    def bug_update_mail(user)
        @user = user
        mail(to: @user.email, subject: '[Colearn] We have discovered a bug in our chat on safari')
    end

    def send_leave_post_mail_inactive_users(post, user)
      @post = post
      @user = user
      mail(to: @user.email, subject: '[Colearn] Inactive! on learning post ' + post.title + '?')
    end

    def mail(*args)
        res = super *args
        if(res.to.length == 0)
            res.perform_deliveries = false
        end
        res
    end

    
end
