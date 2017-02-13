class PushNotificationsController < ApplicationController
	def register_device
		d = DeviceToken.find_or_create_by(token: params[:token])
		d.valid_token = true
		d.version = params[:version] if params[:version]
		if d.valid?
			if current_user
				current_user.device_tokens << d
			end
			d.save!
			render :json => {:success => true, :user_id => d.user.try(:id)}
		else
			Rails.logger.warn "Errors = " + d.errors.messages.inspect
			render :json => {:success => false}
		end
	end
end
