class Category < ActiveRecord::Base
	has_and_belongs_to_many :tags
	has_many :posts, through: :tags
end
