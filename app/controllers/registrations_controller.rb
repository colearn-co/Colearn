class RegistrationsController < Devise::RegistrationsController


	
  def update
  	super
    (params[:interests] || []).each do |interest|
    	begin
    		current_user.interests.push(Interest.find_or_create_by(:title => interest))
    	rescue ActiveRecord::RecordNotUnique => e
    		current_user.interests.push(Interest.find_or_create_by(:title => interest))
    	end
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end