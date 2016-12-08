class InvitesController < ApplicationController
	before_filter :authenticate_user!
	def create
		@post = Post.find(params[:post_id])
  		@invite = @post.invites.build
  		@invite.status = params[:status]
  		@invite.message = params[:invite][:message]
  		@invite.user = current_user
  		@invite.save!
  		flash[:notice] = "Join request sent successfully"
  		render "/#{@post.class.name.underscore}s/invites/response".downcase
	end

	def update
		@post = Post.find params[:post_id]
		if @post.is_member?(current_user)
			@invite = @post.invites.find(params[:id])	
			@invite.update_attributes(:status => params[:status], :accepting_user => current_user)
			flash[:notice] = @invite.status == Invite::STATUS[:accepted] ? "Accepted invite request. You can now start chating." : "Rejected invite requested"
			render "/#{@post.class.name.underscore}s/invites/response".downcase
		else
			render :json => {:error => "invalid request"}
		end	
	end
end