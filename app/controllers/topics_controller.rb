class TopicsController < ApplicationController
	def show
		@topic = Topic.find(params[:id])
	end

	def udacity_posts
		@udacity = Udacity.find(params[:id])
		if @udacity.posts.length == 0
			redirect_to new_post_path(:udacity => @udacity)			
		end
	end
end 