class User < ActiveRecord::Base
	BOT = {
		:email => "bot@colearn.xyz"
	}
	@@colearn_bot = User.find_by(:email => BOT[:email])
  	cattr_reader :colearn_bot
	has_many :posts
	has_many :votes
	has_many :comments
	has_many :chats
	has_many :skills
	has_many :authentications
	has_many :invites
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :participated_posts, through: :accepted_invites, source: :post
	validates_uniqueness_of :email
 	has_many :user_chat_infos
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable,
	 	:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

	include Gravatarify::Base
	after_create :send_welcome_notification, :unless => :welcome_mail_discard

	def is_bot?
		self.email == BOT[:email]
	end

	def send_welcome_notification
		if (!self.email.blank?) 
			UserMailer.welcome_mail(self).deliver
		end
	end

	def chat_info(post)
		self.user_chat_infos.where(:post => post).first
	end


	def self.find_for_auth2(access_token, referrer = nil)
		data = access_token.info
		authentication = Authentication.find_or_initialize_by(:provider => access_token.provider, :uid => access_token.uid)
		find_or_create_user_auth(authentication, data, access_token.credentials.token, referrer)
	end

	def json_info(post)
		self.as_json(User.json_info).merge({
			:online_status => online_status(post),
			:last_visited => last_visited(post)
		})
	end

	def self.json_info
		{
			:only => [:id, :name],
			:methods => [:picture]
		}
	end

	def picture
		gravatar_url(self.email, :d => :monsterid)
	end

	def online_status(post)
		return 'online' if self.is_bot?
		time = self.user_chat_infos.where(:post => post).first.last_visited rescue nil
		Time.now.to_i - time.to_i <= 30 ? "online" : "offline"
	end

	def last_visited(post)
		self.user_chat_infos.where(:post => post).first.last_visited rescue nil
	end

	def self.find_or_create_user_auth(authentication, data, oauth_token, referrer) 
		registered_user = authentication.user || User.where(:email => data[:email]).where.not(:email => nil).first
		if !registered_user
			registered_user = User.create(name: data[:name],
			email: data[:email], password: Devise.friendly_token[0,20],
			:referrer => referrer
			)
		end
		authentication.user = registered_user
		authentication.save!
		registered_user
	end

	def welcome_mail_discard
		self.email == BOT[:email]
	end
end
