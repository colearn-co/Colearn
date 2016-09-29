class Post < ActiveRecord::Base
	belongs_to :user
	has_many :votes, :as => :votable
	has_many :invites
	has_many :accepted_invites, lambda { where(:status => Invite::STATUS[:accepted]) }, class_name: 'Invite'
	has_many :co_users, through: :accepted_invites, :source => :user
	has_many :comments, :as => :commentable

end
