class RegistrationsController < Devise::RegistrationsController



  def update
  	super
    ints = []
    (params[:interests] || []).each do |interest|
    	begin
    		ints.push(Interest.find_or_create_by(:title => interest.capitalize))
    	rescue ActiveRecord::RecordNotUnique => e
    		ints.push(Interest.find_or_create_by(:title => interest.capitalize))
    	end
    end
	current_user.interests = ints
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end