class Invite < ActiveRecord::Base
	STATUS = {
		:requested => 1,
		:accepted => 2,
		:rejected => 3
		
	}
	belongs_to :user
	belongs_to :post
	scope :accepted_invites, -> {where(:status => Invite::STATUS[:accepted])}
	scope :requested_invites, -> {where(:status => Invite::STATUS[:requested])}
	validates_uniqueness_of :user_id, :scope => :post_id

end

