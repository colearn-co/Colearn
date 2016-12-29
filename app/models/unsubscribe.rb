class Unsubscribe < ActiveRecord::Base
	def self.unsunscribe_key(email)
		salt = "123abc"
		Digest::MD5.hexdigest(salt + email)
	end
end
