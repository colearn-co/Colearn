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
	has_and_belongs_to_many :interests
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :participated_posts, through: :accepted_invites, source: :post
	validates_uniqueness_of :email, :allow_nil => true, :on => :save
	validates_uniqueness_of :username
	validate :validate_username

 	has_many :user_chat_infos
 	has_one :user_profile
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
	before_save :create_basic_user_profile
	before_save :add_username_if_not_present
	before_save :fix_cases
	before_save :make_email_nil_if_blank
	has_attached_file :display_pic,
						styles: { small: "50x50", medium: "200x200", large: "500x500"},
	                    :s3_credentials => "#{Rails.root}/config/s3.yml",
	                    :path => ":class/:attachment/:id_partition/:style/:filename",
      					:s3_permissions => :"public-read",
  						:url => ":s3_domain_url"

	validates_attachment_content_type :display_pic, content_type: /\Aimage\/.*\Z/
  	validates_attachment_size :display_pic, :less_than => 10.megabytes
  	accepts_nested_attributes_for :user_profile, :allow_destroy => true
	attr_accessor :login

	def login
	    @login || self.username || self.email 
	end

	def email_required?
  		false
	end
	
	def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["username = :value OR email = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_hash).first
      end
    end

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
			if self.email?
				UserMailer.confirmation_mail(self).deliver
			end
		end
	end

	def chat_info(post)
		self.user_chat_infos.where(:post => post).first
	end

	def is_unsubscribed?
		Unsubscribe.where(:email => self.email).count > 0
	end

	def time_zone_diff(user)
		if self.time_zone_offset && user.time_zone_offset
			user.time_zone_offset - self.time_zone_offset
		else
			return nil			
		end
	end

	def to_param
		self.username
	end


	def time_zone_diff_in_hours(user = nil)
		return nil if self.time_zone_offset.nil?
		return self.time_zone_offset / 60.0 if user.nil?
		diff = time_zone_diff(user)
		if diff
			return diff / 60.0
		else
			return nil
		end
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
			:last_visited => last_visited(post).to_i * 1000
		})
	end

	def user_after_sign_in_info
		self.as_json(:only => [:id, :username], :methods => [:small_pic])

	end

	def small_pic
		self.display_pic.present? ? self.display_pic.url(:small) : gravatar_url(self.email, :d => :monsterid)
	end

	def self.json_info
		{
			:only => [:id, :name, :username],
			:methods => [:small_pic, :app_status]
		}
	end

	def picture
		self.display_pic.present? ? self.display_pic.url(:small) : gravatar_url(self.email, :d => :monsterid)
	end

	def location_text
		self.user_profile.location.presence rescue nil
	end

	def medium_large_picture
		self.display_pic.present? ? self.display_pic.url(:medium) : gravatar_url(self.email, :d => :monsterid, :s => 200)
	end

	def online_status(post)
		return 'online' if self.is_bot?
		time = self.user_chat_infos.where(:post => post).first.last_visited rescue nil
		Time.now.to_i - time.to_i <= 30 ? ONLINE_STATUS[:online] : ONLINE_STATUS[:offline]
	end

	def is_online?(post)
		self.online_status(post) == ONLINE_STATUS[:online]
	end

	def app_status
		self.device_tokens.count == 0 ? 'absent' : 'present'
	end

	def on_app?
		self.device_tokens.count > 0
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
	def fix_cases
		self.email.try(:downcase!)
		self.username.try(:downcase!)
	end
	def add_username_if_not_present
		if !self.username?
			self.username = Haikunator.haikunate(9999, '.') #TODO: check for name conflict.
		end
	end

	def validate_username
		self.username.try(:downcase!)
		if self.username? && !username_valid?(self.username)
			errors.add(:username, "Allowed chars are a-z, 0-9 and '.', '_'")
		end
	end
	def username_valid? str
	    chars = Set.new(('a'..'z').to_a + ('0'..'9').to_a + [".", "_"] )
	    str.chars.detect {|ch| !chars.include?(ch)}.nil?
  	end
  	def make_email_nil_if_blank
  		if self.email.blank?
  			puts "email is blank"
  			self.email = nil;
  		end
  	end

  	def create_basic_user_profile
  		begin
  			self.build_user_profile if self.user_profile.blank?
  			if self.user_profile.location.blank?
	  			self.user_profile.location = Geocoder.search(self.last_sign_in_ip.to_s).first.try(:address)
	  			self.user_profile.save!
	  		end

	  		if self.time_zone_offset.blank?
	  			geo = Geocoder.search(self.last_sign_in_ip.to_s).first.try(:data) || {}
	  			time = Timezone[geo['time_zone']]
	  			if time.valid?
	  				self.update_attributes(:time_zone_offset => time.utc_offset/60)
	  			end
	  		end
  		rescue => e
            ExceptionNotifier.notify_exception(e)
  		end
  	end
end
