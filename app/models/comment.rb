class Comment < ActiveRecord::Base
	belongs_to :user
	default_scope {order(:id => :desc)}
end
