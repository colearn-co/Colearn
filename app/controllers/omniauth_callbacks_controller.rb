class OmniauthCallbacksController < Devise::OmniauthCallbacksController   
	def google_oauth2
	    @user = User.find_for_auth2(request.env["omniauth.auth"])
	 
	    if @user.persisted?
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	      session["devise.google_data"] = request.env["omniauth.auth"]
	      redirect_to new_user_registration_url
	    end
	end

	def facebook
		# You need to implement the method below in your model (e.g. app/models/user.rb)
		@user = User.find_for_auth2(request.env["omniauth.auth"], current_user)

		if @user.persisted?
		  sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
		  set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
		else
		  session["devise.facebook_data"] = request.env["omniauth.auth"]
		  redirect_to new_user_registration_url
		end
	end

  


end