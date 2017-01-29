class Invite < ActiveRecord::Base
	STATUS = {
		:requested => 1,
		:accepted => 2,
		:rejected => 3,
		:left => 4
		
	}
	belongs_to :user
	belongs_to :accepting_user, :class_name => 'User', :foreign_key => 'accepting_user_id'
	belongs_to :post
	scope :accepted_invites, -> {where(:status => Invite::STATUS[:accepted])}
	scope :requested_invites, -> {where(:status => Invite::STATUS[:requested])}
	validates_uniqueness_of :user_id, :scope => :post_id

	after_create :send_notification_to_owner
	after_update :send_confirm_notification
	validate :rejection_message_presence

	def send_notification_to_owner
		if self.status == STATUS[:requested]
			self.post.members.each do|mem|
				UserMailer.join_request_mail(mem, self.user, self.post).deliver
			end
		end
	end

	def is_accepted?
		self.status == STATUS[:accepted]
	end

	def send_confirm_notification

		if self.status_changed?
			if self.status == STATUS[:accepted]
				UserMailer.join_confirmation_mail(self.user, self.post).deliver	
			elsif self.status == STATUS[:rejected]
				UserMailer.join_rejection_mail(self).deliver()
			end				
		end
	end

	def send_rejection_mail
		
	end

	private
	def rejection_message_presence
		if self.status == STATUS[:rejected] && self.reject_message.blank?
			errors.add(:reject_message, "cannot be blank")
		end
	end

end

