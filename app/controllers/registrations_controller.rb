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
    current_user.interests = ints.uniq
    current_user.update_attributes!(user_profile_params)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end


  private
  def user_profile_params
    params.require(:user).permit(:display_pic, :user_profile_attributes => [:id, :about_me, :github])
  end

end