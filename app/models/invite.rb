class Invite < ActiveRecord::Base
	STATUS = {
		:accepted => 1,
		:rejected => 2
	}
	belongs_to :user
	belongs_to :post

end
