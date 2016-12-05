# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	def welcome_mail
		UserMailer.welcome_mail(User.first)
	end
end
