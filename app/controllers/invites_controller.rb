class InvitesController < ApplicationController
	before_filter :authenticate_user!
	def create
		@post = Post.find(params[:post_id])
		if !@post.is_closed?
	  		@invite = @post.invites.build
	  		@invite.status = params[:status]
	  		@invite.message = params[:invite][:message]
	  		@invite.user = current_user
	  		@invite.save!
	  		flash[:notice] = "Join request sent successfully"
	  		render "/#{@post.class.name.underscore}s/invites/response".downcase
	  	else
	  		render :json => {:error => "Post is closed"}
	  	end
	end

	def update
		@post = Post.find params[:post_id]
		if @post.is_member?(current_user)
			@invite = @post.invites.find(params[:id])	
			@invite.update_attributes(:status => params[:status], :accepting_user => current_user, 
				:reject_message => params[:reject_message])
			flash[:notice] = @invite.status == Invite::STATUS[:accepted] ? "Accepted invite request. You can now start chating." : "Rejected invite requested"
			if @invite.valid? && @invite.status == Invite::STATUS[:rejected]
				UserMailer.join_rejection_mail(@invite).deliver()
			end
			render "/#{@post.class.name.underscore}s/invites/response".downcase
		else
			render :json => {:error => "invalid request"}
		end	
	end
end