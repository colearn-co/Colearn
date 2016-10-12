class Vote < ActiveRecord::Base
	TYPE = {
		:upvote => 1,
		:downvote => 2,		
	}
	belongs_to :user
	belongs_to :votable, polymorphic: true
	validates_presence_of :user
	validates_presence_of :votable
	scope :upvotes, -> {where(:type => Vote::TYPE[:upvote])}
	scope :downvotes, -> {where(:type => Vote::TYPE[:downvote])}


end
