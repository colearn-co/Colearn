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
		if @post.is_member?(current_user) || @post.past_member?(current_user)
			@invite = @post.invites.find(params[:id])
			puts "Params:" + params.inspect
			if params[:status] == Invite::STATUS[:left].to_s
				if @post.user.id == current_user.id 
					raise "User can not leave its own post."
				end
				@invite.update_attributes(:status => params[:status],
					:leave_message => params[:invite][:leave_message])
				flash[:notice] = "You have successfully left the learning post"
				redirect_to post_path(@post)	
			elsif params[:status] == Invite::STATUS[:requested].to_s
				@invite.update_attributes(:status => params[:status], 
					:rejoin_message => params[:invite][:rejoin_message])
				flash[:notice] = "Rejoin request sent successfully!"
				render "/#{@post.class.name.underscore}s/invites/response".downcase
			else	
				@invite.update_attributes(:status => params[:status], :accepting_user => current_user, 
					:reject_message => params[:reject_message])
				flash[:notice] = @invite.status == Invite::STATUS[:accepted] ? "Accepted invite request. You can now start chating." : "Invite request rejected"
				render "/#{@post.class.name.underscore}s/invites/response".downcase
			end
		else
			render :json => {:error => "invalid request"}
		end	
	end
end