class UsersController < ApplicationController
	before_filter :authenticate_user!, :only => [:update_time_zone]
	def show
		@user = User.find(params[:id])
	end

	def update_time_zone
		if params[:offset]
			current_user.time_zone_offset = params[:offset].to_i
			current_user.save!
		end
		render :json => {success: true}
	end
	
end
