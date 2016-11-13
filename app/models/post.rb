class Post < ActiveRecord::Base
	belongs_to :user
	has_many :chats,:as => :chatable
	has_many :votes, :as => :votable
	has_many :invites
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :requested_invites, lambda { requested_invites }, class_name: 'Invite'
	has_many :upvotes, lambda { upvotes }, class_name: 'Vote', :as => :votable
	has_many :downvotes, lambda { downvotes }, class_name: 'Vote', :as => :votable
	has_many :members, through: :accepted_invites, source: :user
	has_many :comments, :as => :commentable
	has_many :skills
	has_many :tags
	scope :order_by_recency, -> {order(id: :desc)}
	
	validates_presence_of :user

	validates :title, presence: true,
                    length: { minimum: 1 }
	
	after_create :add_own_user

	accepts_nested_attributes_for :skills
	
	def add_own_user
		Invite.create(:user => self.user, :post => self, :status => Invite::STATUS[:accepted])
	end

	def is_member?(user)
		self.members.include?(user)
	end
	
	def total_vote_count
		self.upvotes.count - self.downvotes.count
	end
end
