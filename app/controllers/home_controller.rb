class HomeController < ApplicationController
	def index
	end

	def feedback
		if !params[:message].strip.blank?
			Feedback.create!(:content => params[:message], :user => current_user)
			render :json => {:success => true}
		end
	end

	def unsubscribe
		auth_key = Unsubscribe.unsunscribe_key(params[:email])
		if params[:auth_key] == auth_key
			Unsubscribe.find_or_create_by(:email => params[:email])			
		end
		render :layout => false
	end

	def user_confirm
		@user = User.find_by(:confirmation_token => params[:token])
		if @user
			@user.update_columns(:confirmed_at => Time.now)
			flash[:notice] = "Your account is confirmed!"	
		else
			flash[:notice] = "No account found"
		end		
		if current_user
			redirect_to root_path
		else
			redirect_to new_user_session_path(:type => 'login')			
		end
	end

end
