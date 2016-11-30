class InvitesController < ApplicationController
	before_filter :authenticate_user!
	def create
		@post = Post.find(params[:post_id])
  		@invite = @post.invites.build
  		@invite.status = params[:status]
  		@invite.message = params[:invite][:message]
  		@invite.user = current_user
  		@invite.save!
  		render "/#{@post.class.name.underscore}s/invites/response".downcase
	end

	def update
		@post = Post.find params[:post_id]
		#only update if post.user is current user.
		@invite = @post.invites.find(params[:id])	
		@invite.update_attributes(:status => params[:status])
		flash[:notice] = @invite.status == Invite::STATUS[:accepted] ? "Accepted invite request" : "Rejected invite requested"
		render "/#{@post.class.name.underscore}s/invites/response".downcase
	end
end