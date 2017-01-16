class User < ActiveRecord::Base
	BOT = {
		:email => "bot@colearn.xyz"
	}
	@@colearn_bot = User.find_by(:email => BOT[:email])
  	cattr_reader :colearn_bot
	ONLINE_STATUS = {
		:online => 'online',
		:offline => 'offline'
	}
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
 	has_and_belongs_to_many :roles
 	has_many :suggestions
 	has_many :device_tokens
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 	:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

	include Gravatarify::Base
	after_create :send_welcome_notification, :unless => :welcome_mail_discard
	after_create :send_confirmation_notification

	def is_bot?
		self.email == BOT[:email]
	end

	def send_welcome_notification
		if (!self.email.blank?) 
			UserMailer.welcome_mail(self).deliver
		end
	end

	def send_confirmation_notification
		if !self.confirmed_at
			self.update_columns(:confirmation_token => SecureRandom.base64(16))
			UserMailer.confirmation_mail(self).deliver
		end
	end

	def chat_info(post)
		self.user_chat_infos.where(:post => post).first
	end

	def is_unsubscribed?
		Unsubscribe.where(:email => self.email).count > 0
	end

	def user_auth_key
		Digest::MD5.hexdigest(self.email + self.created_at.to_i.to_s)
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
		Time.now.to_i - time.to_i <= 30 ? ONLINE_STATUS[:online] : ONLINE_STATUS[:offline]
	end

	def is_online?(post)
		self.online_status(post) == ONLINE_STATUS[:online]
	end

	def last_visited(post)
		self.user_chat_infos.where(:post => post).first.last_visited rescue nil
	end
	def self.find_for_verfied_token_response(auth, provider, oauth_token)
		authentication = Authentication.find_or_initialize_by(:provider => provider, :uid => auth[:id])
		find_or_create_user_auth(authentication, auth, oauth_token, "app")
	end

	def self.find_or_create_user_auth(authentication, data, oauth_token, referrer) 
		registered_user = authentication.user || User.where(:email => data[:email]).where.not(:email => nil).first
		if !registered_user
			registered_user = User.new(name: data[:name],
			email: data[:email], password: Devise.friendly_token[0,20],
			:referrer => referrer,
			:confirmed_at => Time.now
			)
			registered_user.save!
		end
		authentication.user = registered_user
		authentication.save!
		registered_user
	end

	def welcome_mail_discard
		self.email == BOT[:email]
	end
	
	def is_admin?
		!self.roles.admin.blank?
	end

	def is_inactive?
		self.posts.count + self.votes.count + self.comments.count + self.suggestions.count + self.invites.count == 0
	end
end
