class HomeController < ApplicationController
	def index
	end

	def feedback
		if !params[:message].strip.blank?
			Feedback.create!(:content => params[:message], :user => current_user)
			render :json => {:success => true}
		end
	end

end
