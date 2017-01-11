class DeviceToken < ActiveRecord::Base
	belongs_to :user
	default_scope {where(:valid_token => true)}
end
