class Role < ActiveRecord::Base
	ROLE_NAME = {
		:admin => 'admin'
	}
	has_and_belongs_to_many :users
	scope :admin, lambda{ where(:name => ROLE_NAME[:admin])}
end
