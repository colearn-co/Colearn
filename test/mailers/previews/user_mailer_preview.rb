# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	def welcome_mail
		UserMailer.welcome_mail(User.first)
	end
	def join_request_mail 
		UserMailer.join_request_mail(User.first, User.last, Post.first);
	end
	def join_confirmation_mail 
		UserMailer.join_confirmation_mail(User.first, Post.first);
	end
	def join_rejection_mail
		invite = Invite.last;
		invite.message = "This is a rejection message for testing";
		UserMailer.join_rejection_mail(invite);
	end

	def post_chat_followup
		user = User.last;
		post = Post.last;
		UserMailer.post_chat_followup(user, post);
	end
	def posts_summary
		user = User.last;
		posts = Post.last(3);
		UserMailer.posts_summary(user, posts);
	end

	def download_app
		user = User.first;
		UserMailer.download_app(user);
	end
	def bug_update_mail
		user = User.first;
		UserMailer.bug_update_mail(user);
	end

	def send_leave_post_mail_inactive_users
		user = User.last;
		UserMailer.send_leave_post_mail_inactive_users(Post.first, user);
	end

end
