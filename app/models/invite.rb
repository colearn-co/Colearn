class Invite < ActiveRecord::Base
	STATUS = {
		:requested => 1,
		:accepted => 2,
		:rejected => 3
		
	}
	belongs_to :user
	belongs_to :accepting_user, :class_name => 'User', :foreign_key => 'accepting_user_id'
	belongs_to :post
	scope :accepted_invites, -> {where(:status => Invite::STATUS[:accepted])}
	scope :requested_invites, -> {where(:status => Invite::STATUS[:requested])}
	validates_uniqueness_of :user_id, :scope => :post_id

	after_create :send_notification_to_owner
	after_update :send_confirm_notification

	def send_notification_to_owner
		if self.status == STATUS[:requested]
			UserMailer.join_request_mail(self.post.user, self.user, self.post).deliver
		end
	end

	def send_confirm_notification
		if self.status == STATUS[:accepted]
			UserMailer.join_confirmation_mail(self.user, self.post).deliver	
		end
	end

end

