class InterestsController < ApplicationController
	def search
		@interests = Interest.search(params)
		render :json => @interests.map(&:json_data)
	end
end
