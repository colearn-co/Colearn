class Invite < ActiveRecord::Base
	STATUS = {
		:requsted => 1,
		:accepted => 2,
		:rejected => 3
		
	}
	belongs_to :user
	belongs_to :post
	scope :accepted_invites, -> {where(:status => Invite::STATUS[:accepted])}
	validates_uniqueness_of :user_id, :scope => :post_id

	after_update :add_co_user

end
