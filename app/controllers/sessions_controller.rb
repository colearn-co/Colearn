class SessionsController < Devise::SessionsController 
  respond_to :json

  def render(*args)
  	if request.format == :json && @render_override.nil?
  		@render_override = true
  		render :json => current_user.user_after_sign_in_info
  	else
  		super *args
  	end
  end
end