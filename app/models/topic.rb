class Topic < ActiveRecord::Base
	has_and_belongs_to_many :tags
	has_many :posts, through: :tags

	def to_param
		"#{id}-#{self.title.gsub(/[^0-9A-Za-z]/,"-").gsub(/[-]+/, "-")}"
	end
end
