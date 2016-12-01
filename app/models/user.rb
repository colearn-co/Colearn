class User < ActiveRecord::Base
	has_many :posts
	has_many :votes
	has_many :comments
	has_many :chats
	has_many :skills
	has_many :authentications
	has_many :invites
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :participated_posts, through: :accepted_invites, source: :post
 	
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 	:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

	def self.find_for_auth2(access_token, signed_in_resource=nil)
		data = access_token.info
		authentication = Authentication.find_or_initialize_by(:provider => access_token.provider, :uid => access_token.uid)
		find_or_create_user_auth(authentication, data, access_token.credentials.token)
	end

	def self.find_or_create_user_auth(authentication, data, oauth_token) 
		registered_user = authentication.user || User.where(:email => data[:email]).where.not(:email => nil).first
		if !registered_user
			registered_user = User.create(name: data[:name],
			email: data[:email], password: Devise.friendly_token[0,20],
			)
		end
		authentication.user = registered_user
		authentication.save!
		registered_user
	end
end
