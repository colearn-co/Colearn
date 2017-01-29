class Interest < ActiveRecord::Base
	has_and_belongs_to_many :users
	validates_uniqueness_of :title
	before_save :fix_case

	def self.search(params)
		self.where("title like '%#{params[:keyword]}%'").limit(params[:limit] || 5)
	end

	def json_data
		{
			:id => self.title,
			:title => self.title
		}
	end

	def fix_case
		self.title = self.title.capitalize
	end
end
