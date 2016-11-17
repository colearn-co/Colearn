class Vote < ActiveRecord::Base
	TYPE = {
		:upvote => 1,
		:downvote => 2,		
		:none => 0
	}
	belongs_to :user
	belongs_to :votable, polymorphic: true
	validates_presence_of :user
	validates_presence_of :votable
	validates_uniqueness_of :user_id, {scope: [:votable_type, :votable_id]} 

	scope :upvotes, -> {where(:vote_type => Vote::TYPE[:upvote])}
	scope :downvotes, -> {where(:vote_type => Vote::TYPE[:downvote])}


end
