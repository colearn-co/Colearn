class Post < ActiveRecord::Base
	belongs_to :user
	has_many :chats,:as => :chatable
	has_many :votes, :as => :votable
	has_many :invites
	has_many :accepted_invites, lambda { accepted_invites }, class_name: 'Invite'
	has_many :co_users, through: :accepted_invites, :source => :user
	has_many :comments, :as => :commentable
	after_create :add_own_user

	def add_own_user
		Invite.create(:user => self.user, :post => self, :status => Invite::STATUS[:accepted])
	end



end
