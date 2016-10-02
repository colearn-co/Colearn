class InvitesController < ApplicationController
	
	def create
		@post = Post.find(params[:post_id])
  		@invite = @post.invites.build
  		@invite.status = params[:status]
  		@invite.user = current_user
  		@invite.save
  		render "/#{@post.class.name.underscore}s/invites/response".downcase
	end

	def update
		@post = Post.find params[:post_id]
		@post.update(:status => params[:status])
	end
end