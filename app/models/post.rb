class Post < ActiveRecord::Base
	STATUS = {
		:open => 1,
		:closed => 2
	}	
	PUBLISH_STATUS = {
		:unpublished => 1,
		:published => 2
	}
	MAX_ALLOWED_MEMBERS = [2, 4, 8, 16, 20]
	belongs_to :user
	has_many :chats,:as => :chatable
	has_many :votes, :as => :votable
	has_many :invites
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :requested_invites, lambda { requested_invites }, class_name: 'Invite'
	has_many :available_invites, lambda { accepted_or_requested }, class_name: 'Invite'
	has_many :left_invites, lambda { left_invites }, class_name: 'Invite'
	has_many :upvotes, lambda { upvotes }, class_name: 'Vote', :as => :votable
	has_many :downvotes, lambda { downvotes }, class_name: 'Vote', :as => :votable
	has_many :members, through: :accepted_invites, source: :user
	has_many :other_members, lambda {|v| where.not(:id => v.user_id)}, through: :accepted_invites, source: :user
	has_many :past_members, through: :left_invites, source: :user
	has_many :comments, :as => :commentable
	has_many :skills
	has_and_belongs_to_many :tags
	has_many :user_chat_infos
	has_many :suggestions
	belongs_to :udacity
	scope :order_by_recency, -> {order(id: :desc)}
	scope :order_by_popularity, -> {order(popularity: :desc)}
	scope :published, -> { where.not(:publish_status => PUBLISH_STATUS[:unpublished]) }
	
	validates_presence_of :user

	validates :title, presence: true,
                    length: { minimum: 1 }      
	
	after_create :add_own_user
	before_create :fill_publish_status

	accepts_nested_attributes_for :skills
	has_paper_trail


	def self.search(params)
		self.where("lower(title) like '%#{params[:keyword].downcase}%' or lower(message) like '%#{params[:keyword].downcase}%'").limit(params[:limit] || 10)
	end


	def getUserInvite(user) 
		self.invites.find_by(:user => user)
	end

	def self.min_followup_time
		24.hours.to_i
	end
	
	def invite_threshold_reached?
		self.available_invites.count >= self.max_members
	end

	def post_card_json
		self.as_json(:only => [:id, :title, :message])
	end

	def add_own_user
		Invite.create(:user => self.user, :post => self, :status => Invite::STATUS[:accepted])
	end

	def create_user_chat(usr, params)
		chat = Chat.new(Chat.chat_params(params))
  		chat.user = usr

  		self.chats.push(chat)# @chatable.chats << @chat= Chat.new(chat_params)
  		chat.save!
  		if !params[:avatar].blank?
  			chat_resource = ChatResource.new(:avatar => params[:avatar], :chat => chat)
  			chat_resource.save!
  		end
        chat
    end

	def unread_messages_count(usr)
		begin
			last_visited = self.user_chat_infos.where(:user => usr).first.last_visited
			return self.chats.where("created_at > ?", last_visited).count
		rescue => e
			return 0
		end
	end

	def chatting_allowed?(usr)
		!usr.is_admin? && self.members.include?(usr)
	end

	def user_visited_post_chat(user)
		info = UserChatInfo.find_or_create_by(:user => user, :post => self)
		info.update_attributes(:last_visited => Time.now)
	end

	def is_member?(user)
		self.members.include?(user)
	end

	def past_member?(user) 
		self.past_members.include?(user)
	end

	def member_excluding_owner?(user) 
		return (!user.nil?) && self.user.id != user.id && self.members.include?(user)
	end

	def mark_closed
		self.update_attributes(:status => Post::STATUS[:closed])
	end

	def mark_open
		self.update_attributes(:status => Post::STATUS[:open])
	end

	def is_closed?
		self.status == STATUS[:closed]
	end

	def user_requested?(user)
		self.requested_invites.map(&:user).include?(user)
	end

	def to_param
		"#{id}-#{self.title.gsub(/[^0-9A-Za-z]/,"-").gsub(/[-]+/, "-")}"
	end
	
	def total_vote_count
		self.upvotes.count - self.downvotes.count
	end

	def user_vote(user)
		self.votes.where(user: user).first
	end

	def user_vote_type(user)
		self.votes.where(user: user).first.try(:vote_type)
	end

	def fill_publish_status
		if self.publish_status.blank?
			self.publish_status = PUBLISH_STATUS[:published]
		end
	end

	def self.chat_followup
		Post.includes(:members).find_each(batch_size: 10) do |post|
			post.members.each do |mem|

				next if mem.is_unsubscribed?

				last_chat = post.chats.last
				if last_chat && last_chat.created_at.to_i > mem.last_visited(post).to_i &&
					last_chat.created_at.to_i > post.last_followup_time(mem) &&
					last_chat.user_id != mem.id &&
				 	Time.now.to_i - mem.last_visited(post).to_i > Post.min_followup_time && 
					Time.now.to_i - post.last_followup_time(mem) > Post.min_followup_time
					puts "sending mail to #{mem.email}"
					post.send_followup_mail(mem)					
				end
			end
		end
	end

	def send_email_to_inactive_users user
		if self.members.include?(user)
				UserMailer.send_leave_post_mail_inactive_users(self, user).deliver
		end
	end

	def send_followup_mail(current_user)
		UserMailer.post_chat_followup(current_user, self).deliver
		update_last_followup_time(current_user)
	end

	def user_followup_key(usr)
		"#{self.id}-#{usr.id}"
	end

	def last_followup_time_key
			RedisKeys::LAST_MAIL_FOLLOWUP_TIME
	end

	def last_followup_time(current_user)
		$redis.hget(self.last_followup_time_key, user_followup_key(current_user)).to_i
	end

	def update_last_followup_time(current_user)
		$redis.hset(self.last_followup_time_key, user_followup_key(current_user), Time.now.to_i)
	end

end
