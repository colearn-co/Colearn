class Skill < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	has_paper_trail
end
