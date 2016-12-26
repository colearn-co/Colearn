class Suggestion < ActiveRecord::Base
	has_many :votes, :as => :votable
	belongs_to :user
	belongs_to :post
	validates :message, presence: true,
                    length: { minimum: 1 }  
	has_many :upvotes, lambda { upvotes }, class_name: 'Vote', :as => :votable
	has_many :downvotes, lambda { downvotes }, class_name: 'Vote', :as => :votable 
    def user_vote_type(user)
		self.votes.where(user: user).first.try(:vote_type)
	end
	def total_vote_count
		self.upvotes.count - self.downvotes.count
	end
end
