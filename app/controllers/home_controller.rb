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

end
