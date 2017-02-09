class InvitesController < ApplicationController
	before_filter :authenticate_user!
	def create
		@post = Post.find(params[:post_id])
		if @post.invite_threshold_reached?
			render :json => {:error => "No more members are allowed"}
		elsif !@post.is_closed?
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
		# TODO: TO much logic here. Next time don't add more logic refactor it and try to move the logic to the model.
		@post = Post.find params[:post_id]
		if @post.is_member?(current_user) || @post.past_member?(current_user)
			@invite = @post.invites.find(params[:id])
			if params[:status] == Invite::STATUS[:left].to_s
				if @post.user.id == current_user.id 
					raise "User can not leave its own post."
				end
				@invite.update_attributes(:status => params[:status],
					:leave_message => params[:invite][:leave_message])
				flash[:notice] = "You have successfully left the learning post"
					
			elsif params[:status] == Invite::STATUS[:requested].to_s
				@invite.update_attributes(:status => params[:status], 
					:rejoin_message => params[:invite][:rejoin_message])
				flash[:notice] = "Rejoin request sent successfully!"
			else	
				@invite.update_attributes(:status => params[:status], :accepting_user => current_user, 
					:reject_message => params[:reject_message])
				flash[:notice] = @invite.status == Invite::STATUS[:accepted] ? "Accepted invite request. You can now start chating." : "Invite request rejected"
			end
			render "/#{@post.class.name.underscore}s/invites/response".downcase
		else
			render :json => {:error => "invalid request"}
		end	
	end
end